class Dgraph < Formula
  desc "Fast, Distributed Graph DB"
  homepage "https://dgraph.io"
  url "https://github.com/dgraph-io/dgraph/archive/v20.03.3.tar.gz"
  sha256 "1e2145d8921b980882ef4475c82337e80c15fa3012a012424dadc9f636bffaa1"

  bottle do
    cellar :any_skip_relocation
    sha256 "7327188d743a976cd47fc7825f4244151156620696e5dcb44102f2539a2eeac9" => :catalina
    sha256 "c79c13833f7baa22bb5949a2d6e98387fdec0abb5d2d18dbac8808a25cef0737" => :mojave
    sha256 "dc1822ecc9337a917b72b525edb8df3129e8917efba969ecd9118f13041b3dc0" => :high_sierra
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
