class Ahoy < Formula
  desc "Creates self documenting CLI programs from commands in YAML files"
  homepage "https://github.com/ahoy-cli/ahoy/"
  url "https://github.com/ahoy-cli/ahoy/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "e57f908df16c29d5e1b5e814496d0f9eb9e11a871ed68e1fd93aa286c557c540"
  license "MIT"
  head "https://github.com/ahoy-cli/ahoy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1d4f45c4c570160683c363f45827d0e8632297f68794018f8686ca1e88f02ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39cc43e109a7f06f80f5bbea045f5877292645bebdc4e8dda3dcc60699bef370"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39cc43e109a7f06f80f5bbea045f5877292645bebdc4e8dda3dcc60699bef370"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "39cc43e109a7f06f80f5bbea045f5877292645bebdc4e8dda3dcc60699bef370"
    sha256 cellar: :any_skip_relocation, sonoma:        "fde6ef7692a9bf8513258596831c349e349b49beea85ff7ba06c0046305e3156"
    sha256 cellar: :any_skip_relocation, ventura:       "fde6ef7692a9bf8513258596831c349e349b49beea85ff7ba06c0046305e3156"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d628f6bd4c2687f8b9736b8b365e311472af4b81dfe798014816b436e08d8fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "689b92185a351f9b622340c9fc7c1234df8a33e6bea026075bb79f52e2de13c5"
  end

  depends_on "go" => :build

  def install
    cd "v2" do
      system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}-homebrew")
    end
  end

  test do
    (testpath/".ahoy.yml").write <<~YAML
      ahoyapi: v2
      commands:
        hello:
          cmd: echo "Hello Homebrew!"
    YAML
    assert_equal "Hello Homebrew!\n", shell_output("#{bin}/ahoy hello")

    assert_equal "#{version}-homebrew", shell_output("#{bin}/ahoy --version").strip
  end
end
