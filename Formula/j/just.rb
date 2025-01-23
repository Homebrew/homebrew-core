class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/refs/tags/1.39.0.tar.gz"
  sha256 "8a900072d7f909bc91030df5896168752bb9108967dbb7149d2cfb11fdeb087a"
  license "CC0-1.0"
  head "https://github.com/casey/just.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15d0c73b969a73eaaa22c25abdc1f05dfa1f28c0721067f978368c4b5936ecc4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a98401c5b5d28909bf243c3a01c557355ea4b2d916aae0ec7930550067c63e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1bc92b85a213de51d153c9927f273c3183eb3d0bd769a9a29847650e9a3b14ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "7445a51dd6706374e495b9df33b0a46cc6110f88e0d38596d235473946dc46fc"
    sha256 cellar: :any_skip_relocation, ventura:       "e718fbb333eefa72e475ffe1e94eef0fc95ebc24062cd4b18bc8f71b5a78da0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fc44f3b4f0ada03ed8263c4a4e62c7fb7e0e4b1410791ab8bbac4967257a2462"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"just", "--completions")
    (man1/"just.1").write Utils.safe_popen_read(bin/"just", "--man")
  end

  test do
    (testpath/"justfile").write <<~EOS
      default:
        touch it-worked
    EOS
    system bin/"just"
    assert_predicate testpath/"it-worked", :exist?

    assert_match version.to_s, shell_output("#{bin}/just --version")
  end
end
