class Dgraph < Formula
  desc "Fast, Distributed Graph DB"
  homepage "https://dgraph.io"
  url "https://github.com/dgraph-io/dgraph/archive/v20.07.0.tar.gz"
  sha256 "46b5deac70d09343644ce10fa69fc313589c7474d974ec720c24504883dd65c1"
  # Source code in this repository is variously licensed under the Apache Public License 2.0 (APL)
  # and the Dgraph Community License (DCL). A copy of each license can be found in the licenses directory.
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "a70082d429c96f24ea28cd4f1dfd5d3f25ff7237b9c44608c4b3504908004f08" => :catalina
    sha256 "c97b04f4a5130d7533388966bfce3c902d23ae4272f3132d2f7b1933f87d7d2f" => :mojave
    sha256 "c5210a45780334e785e1e231ceae9a67aab1a8cd81adcb1224268f421525b2a5" => :high_sierra
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
