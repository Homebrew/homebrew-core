class Forego < Formula
  desc "Foreman in Go for Procfile-based application management"
  homepage "https://github.com/ddollar/forego"
  url "https://github.com/ddollar/forego/archive/refs/tags/20180216151118.tar.gz"
  sha256 "23119550cc0e45191495823aebe28b42291db6de89932442326340042359b43d"
  license "Apache-2.0"
  head "https://github.com/ddollar/forego.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "c0ecd5f1aa248b2ebc4611679e8f8a34ca3330db2cc069bdab6a3ead41f0328d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ef67ea741e0294b822fc3dfb3cfd124e9621b2c8f24ab6e8c023f95782cd81eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f46dbdf37d045a718a27858ca874d1eb69b67bbd04e5778f549e4f632dd4f01a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "544f9c669387997e9197bf3de714106580d23b38fbcd7ba5d5dfba80876563e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "add9895abd190b3c092406ff31939139d7f4e84ea4b8826a3e81e701ce5a482f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae42636ee209a05effd8db31e34d9458bac997f778227eb9bab935fc3699f3fa"
    sha256 cellar: :any_skip_relocation, sonoma:         "ca8e06c8d2b7621ba4e437ca2e00ff528b9c536c6d9c7736fe9f4fbd20d67fba"
    sha256 cellar: :any_skip_relocation, ventura:        "26c2704d12c1d17ec4a2c5da4d57088de37c98d08403771e1bc216bf39ac1fef"
    sha256 cellar: :any_skip_relocation, monterey:       "cc406f5189dfc536b2cf7cc3e9bdbc955717630027770be5c73f8684ca607a5e"
    sha256 cellar: :any_skip_relocation, big_sur:        "3aa5d4a73ba9ec2d2905bac72b65166394c33d7f6ade2cd842d7e7eeceaedd34"
    sha256 cellar: :any_skip_relocation, catalina:       "3004f019d2361f0831bcd83d6f7f6d581f666be9c8a5a6e0a3b81f84d3170146"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "d354729a8747da5e6c6dfa8ca5860362b62a601db82c0d2c71954cea238ed80a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab6668d38416f11e79a39db7a65ce6bc60bce14db6962ca7c06c104c2b69d456"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "off"
    (buildpath/"src/github.com/ddollar/forego").install buildpath.children
    cd "src/github.com/ddollar/forego" do
      ldflags = "-X main.Version=#{version} -X main.allowUpdate=false"
      system "go", "build", *std_go_args(ldflags:)
    end
  end

  test do
    (testpath/"Procfile").write "web: echo \"it works!\""
    assert_match "it works", shell_output("#{bin}/forego start")
  end
end
