class Hz < Formula
  desc "Golang HTTP framework for microservices"
  homepage "https://github.com/cloudwego/hertz"
  url "https://github.com/cloudwego/hertz/archive/refs/tags/cmd/hz/v0.8.0.tar.gz"
  sha256 "7ba7009eb648cdc69840e645408ca1176c5c906db80873dfe54db972da40f591"
  license "Apache-2.0"
  head "https://github.com/cloudwego/hertz.git", branch: "develop"

  livecheck do
    url :stable
    regex(%r{^cmd/hz/v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "41ac86de353c49f8d85329d18741fe48d4ed5e56d744306f780fe576f9f7ea68"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bce7929361350fc34d2313c6fa970200bbfe13fda2a018f1a5a366dfc7c5836d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "039541c04f9d0ca0ecd904feca3467bf0607000c1d50a34b761cc4488206a73e"
    sha256 cellar: :any_skip_relocation, sonoma:         "f87d2f856717d792af42247ac476280159433eb30c48fea32f3064f448f0e571"
    sha256 cellar: :any_skip_relocation, ventura:        "d3d20a8cea60f3358bbe1df30289c1bf00637d1b9911f1936be207e69625c2db"
    sha256 cellar: :any_skip_relocation, monterey:       "6cc376a4ba9291b8621d89a35774184c70d502b1516c7959539c1ac84d31ad55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59f43d6fdcfdbe2c33399156343d8c7704b6dd858080b71d0b3cd8f0c8d6099a"
  end

  depends_on "go" => :build

  def install
    cd "cmd/hz" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
    bin.install_symlink "#{bin}/hz" => "thrift-gen-hertz"
    bin.install_symlink "#{bin}/hz" => "protoc-gen-hertz"
  end

  test do
    output = shell_output("#{bin}/hz --version 2>&1")
    assert_match "hz version v#{version}", output

    system "#{bin}/hz", "new", "--mod=test"
    assert_predicate testpath/"main.go", :exist?
    refute_predicate (testpath/"main.go").size, :zero?
  end
end
