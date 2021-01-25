class Prototool < Formula
  desc "Your Swiss Army Knife for Protocol Buffers"
  homepage "https://github.com/uber/prototool"
  url "https://github.com/uber/prototool/archive/v1.10.0.tar.gz"
  sha256 "5b516418f41f7283a405bf4a8feb2c7034d9f3d8c292b2caaebcd218581d2de4"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "c667e52b752c52d3c852a084dad1fb962e3cbdfd75fac5a7092a691f748cd63e" => :big_sur
    sha256 "ce505a3c8ebc53f48ffee3f5a174073364f462538f4c94458b54dc3e15669106" => :arm64_big_sur
    sha256 "e7c678d2842ce666ddfbeee1092c2354a420c9b8b94244e8db2b382f6568e536" => :catalina
    sha256 "256435ac965872664fc2707b8188090c2a1d369308ef2b224d53e1b972ee7620" => :mojave
    sha256 "373cf39c37bd40c8eb4f9261129226bf0f276771872060ea3495d6a2d56fa911" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "make", "brewgen"
    cd "brew" do
      bin.install "bin/prototool"
      bash_completion.install "etc/bash_completion.d/prototool"
      zsh_completion.install "etc/zsh/site-functions/_prototool"
      man1.install Dir["share/man/man1/*.1"]
      prefix.install_metafiles
    end
  end

  test do
    system bin/"prototool", "config", "init"
    assert_predicate testpath/"prototool.yaml", :exist?
  end
end
