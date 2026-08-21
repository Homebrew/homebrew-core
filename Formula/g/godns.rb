class Godns < Formula
  desc "Dynamic DNS client with multiple providers support"
  homepage "https://github.com/TimothyYe/godns"
  url "https://github.com/TimothyYe/godns/archive/refs/tags/v3.4.3.tar.gz"
  sha256 "0a38ffd19b39371d9e28970679d74b4c04f8476a2f19ea8966a0b9767248f63e"
  license "Apache-2.0"
  head "https://github.com/TimothyYe/godns.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a96eb3f4ba53abfe06213c7393f67cce73114aa8d7a01679db49ff07a1fb1068"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a96eb3f4ba53abfe06213c7393f67cce73114aa8d7a01679db49ff07a1fb1068"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a96eb3f4ba53abfe06213c7393f67cce73114aa8d7a01679db49ff07a1fb1068"
    sha256 cellar: :any_skip_relocation, sonoma:        "adb38660cad7d491e2b6923dc27a1443bea36a8cd46a9c43c4a71f678614979b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d58e3919a788ab173dea659d142c2d33d5dca3f0a5dfaa1a4cce89cc687643a0"
    sha256 cellar: :any,                 x86_64_linux:  "ee6bd27283c1db163028a8eec9c4fd2071ee82402da54d5ce1685c5e692ee9c3"
  end

  depends_on "go" => :build

  resource "web" do
    url "https://github.com/TimothyYe/godns/releases/download/v3.4.3/godns-web-v3.4.3.zip"
    sha256 "4e845347cf580e8c25350423c8c28003bc2ab3c978a80eb8c336c9861e70d0a6"

    livecheck do
      formula :parent
    end
  end

  def install
    resource("web").stage(buildpath/"internal/server/out")
    system "go", "build", *std_go_args(ldflags: "-X main.Version=v#{version}"), "./cmd/godns"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/godns -h")

    (testpath/"config.json").write "{}"
    output = shell_output("#{bin}/godns -c #{testpath}/config.json 2>&1", 1)
    assert_match "Invalid settings", output
  end
end
