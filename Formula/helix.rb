class Helix < Formula
  desc "Post-modern modal text editor"
  homepage "https://helix-editor.com"
  url "https://github.com/helix-editor/helix.git",
       tag:      "v0.6.0",
       revision: "ac1b7d8d0a608f47edfee2872d414e94fd26cc31"
  license "MPL-2.0"
  head "https://github.com/helix-editor/helix.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "helix-term")
    libexec.install "runtime"
    bin.env_script_all_files libexec/"bin", HELIX_RUNTIME: libexec/"runtime"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hx --version")
  end
end
