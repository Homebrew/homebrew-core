class Prototool < Formula
  desc "Your Swiss Army Knife for Protocol Buffers"
  homepage "https://github.com/uber/prototool"
  url "https://github.com/uber/prototool/archive/v1.10.0.tar.gz"
  sha256 "5b516418f41f7283a405bf4a8feb2c7034d9f3d8c292b2caaebcd218581d2de4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0a778ccfbbeaef3a52afc1cb3bbec4d48c3b7c618b88cef6a52d90c4422f88d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ce505a3c8ebc53f48ffee3f5a174073364f462538f4c94458b54dc3e15669106"
    sha256 cellar: :any_skip_relocation, monterey:       "ae13c21f5c59d7fbd664fa74cd526cf0c39df04ca6c066656d27f32b19d72349"
    sha256 cellar: :any_skip_relocation, big_sur:        "c667e52b752c52d3c852a084dad1fb962e3cbdfd75fac5a7092a691f748cd63e"
    sha256 cellar: :any_skip_relocation, catalina:       "e7c678d2842ce666ddfbeee1092c2354a420c9b8b94244e8db2b382f6568e536"
    sha256 cellar: :any_skip_relocation, mojave:         "256435ac965872664fc2707b8188090c2a1d369308ef2b224d53e1b972ee7620"
    sha256 cellar: :any_skip_relocation, high_sierra:    "373cf39c37bd40c8eb4f9261129226bf0f276771872060ea3495d6a2d56fa911"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b193cacb23781483394900b2067c93a1abe8cafe846993a86171ed772c9b18ff"
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
