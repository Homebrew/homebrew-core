class Dgraph < Formula
  desc "Fast, Distributed Graph DB"
  homepage "https://dgraph.io"
  url "https://github.com/dgraph-io/dgraph/archive/v20.11.2.tar.gz"
  sha256 "12b68b033c3741f528dfba6952520ac931d9cb640f0d1e44c99ff85541c9a60a"
  # Source code in this repository is variously licensed under the Apache Public License 2.0 (APL)
  # and the Dgraph Community License (DCL). A copy of each license can be found in the licenses directory.
  license "Apache-2.0"
  head "https://github.com/dgraph-io/dgraph.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0e39e8efd111d1c7c0f7125b90e943d397db9eca348f4082c3f49f8a343367cf"
    sha256 cellar: :any_skip_relocation, big_sur:       "a1ff46e3aa37fdddd19e556a4b19cf7025e729b3cff61bdc0d05bf38b96addd6"
    sha256 cellar: :any_skip_relocation, catalina:      "3a6473f330c65ed91bfbe3dc69900f730893f378ca38ff0a0ccb6a046c02045d"
    sha256 cellar: :any_skip_relocation, mojave:        "c1579bbb0bd88c9d8e376eee6a4075ff94134442ffe624c88e3e1c5fdd0a11c2"
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
