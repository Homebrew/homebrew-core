class Dgraph < Formula
  desc "Fast, Distributed Graph DB"
  homepage "https://dgraph.io"
  url "https://github.com/dgraph-io/dgraph/archive/v20.11.3.tar.gz"
  sha256 "cf0ed5d61dff1d0438dc5b211972d8f64b40dcadebf35355060918c3cf0a6e62"
  # Source code in this repository is variously licensed under the Apache Public License 2.0 (APL)
  # and the Dgraph Community License (DCL). A copy of each license can be found in the licenses directory.
  license "Apache-2.0"
  head "https://github.com/dgraph-io/dgraph.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88693da8a26b8104d2362cc17f6f4311de51d96d1e0bd608e9042f77cdd6bf15"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "28d00b7cc12ab6eb34da4240b7075ee322ff51cd94223d7a8892c823f91bf5cc"
    sha256 cellar: :any_skip_relocation, monterey:       "e9e8e32d5a6def3565d2d5f68dd1b6cf2a5d40f768fad0862213d24d1493a03b"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e2da2c025d3b8f89d4716be724942f7c284c9d0ac70c77fed7c287a31abdb56"
    sha256 cellar: :any_skip_relocation, catalina:       "9d2545b3b0e293d8e48b4c23887bef147f1f1444735dacbf70eb9585bd25502e"
    sha256 cellar: :any_skip_relocation, mojave:         "57fa2f974e4e0313fb58f7e35e2d9547a4d43319af7e84a4fc6619238e862885"
  end

  deprecate! date: "2021-06-10", because: :unsupported

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
