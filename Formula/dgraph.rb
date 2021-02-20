class Dgraph < Formula
  desc "Fast, Distributed Graph DB"
  homepage "https://dgraph.io"
  url "https://github.com/dgraph-io/dgraph/archive/v20.11.1.tar.gz"
  sha256 "b70c80d516b728081a67f6a4d2dbc8ffb74ba82df6068b5c3561e3fc96b5092d"
  # Source code in this repository is variously licensed under the Apache Public License 2.0 (APL)
  # and the Dgraph Community License (DCL). A copy of each license can be found in the licenses directory.
  license "Apache-2.0"
  head "https://github.com/dgraph-io/dgraph.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "783faa5e8541f8117d1a830675f4ebf97b44a75b2f8703fe5cd8fb0ad520f129"
    sha256 cellar: :any_skip_relocation, big_sur:       "d9f6184eabe58ac2ffe70348101d7b5faa5592807b649c464749317c82a7331b"
    sha256 cellar: :any_skip_relocation, catalina:      "39f4a8a78fe7dd86e091721069b65b6c41b6d874f5b6bdab3a04056b2b2a6fe8"
    sha256 cellar: :any_skip_relocation, mojave:        "b5e991c811c8c43ac0df4a465192736aeb42bce572c34631ec4a31aa8de9c6c8"
  end

  depends_on "go" => :build
  depends_on "jemalloc"

  def install
    ENV["GOBIN"] = bin
    system "make", "HAS_JEMALLOC=jemalloc", "oss_install"
  end

  test do
    fork do
      exec bin/"dgraph", "zero"
    end
    fork do
      exec bin/"dgraph", "alpha", "--lru_mb=1024"
    end
    sleep 10

    (testpath/"mutate.json").write <<~EOS
      {
        "set": [
          {
            "name": "Karthic",
            "age": 28,
            "follows": {
              "name": "Jessica",
              "age": 31
            }
          }
        ]
      }
    EOS

    (testpath/"query.graphql").write <<~EOS
      {
        people(func: has(name), orderasc: name) {
          name
          age
        }
      }
    EOS

    system "curl", "-s", "-H", "Content-Type: application/json",
      "-XPOST", "--data-binary", "@#{testpath}/mutate.json",
      "http://localhost:8080/mutate?commitNow=true"

    command = %W[
      curl -s -H "Content-Type: application/graphql+-"
      -XPOST --data-binary @#{testpath}/query.graphql
      http://localhost:8080/query
    ]
    response = JSON.parse(shell_output(command.join(" ")))
    expected = [{ "name" => "Jessica", "age" => 31 }, { "name" => "Karthic", "age" => 28 }]
    assert_equal response["data"]["people"], expected
  ensure
    system "pkill", "-9", "-f", "dgraph"
  end
end
