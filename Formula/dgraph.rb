class Dgraph < Formula
  desc "Fast, Distributed Graph DB"
  homepage "https://dgraph.io"
  url "https://github.com/dgraph-io/dgraph/archive/v20.07.2.tar.gz"
  sha256 "4474f3efad9d16d6d1a82eda6f1ad8e187194e933aeec5de3b42cf9463f6301c"
  # Source code in this repository is variously licensed under the Apache Public License 2.0 (APL)
  # and the Dgraph Community License (DCL). A copy of each license can be found in the licenses directory.
  license "Apache-2.0"
  head "https://github.com/dgraph-io/dgraph.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "7ac1f2a4a9af53e4fa6ee2137825e1095417b9f066acf4cb82b2ccf0a70f6007" => :big_sur
    sha256 "2b82433d3cf3925380091c736f1e0eda58ecf7d81dda1531530857a179c43ec9" => :arm64_big_sur
    sha256 "8bafc5de5848440c3f1c978a475c128432029a638f2d2febf7104fc1bfc73533" => :catalina
    sha256 "57e295bc99e16fa92f1253752957530c97d102c1c713ca89e6d59cc6a3c07a3c" => :mojave
    sha256 "0150fc8ae2de160040728047de34b74223f4f3ecedd2b979df64c220b609074a" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOBIN"] = bin
    system "make", "oss_install"
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
