class GpgTui < Formula
  desc "Manage your GnuPG keys with ease!"
  homepage "https://github.com/orhun/gpg-tui"
  url "https://github.com/orhun/gpg-tui/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "ecc232b42ff07888eb12a43daf5a956791a21efc85f6e71fbed9b9769ec50b50"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "abbd155171e756035475b2d056af6a211670e7771f0c5b4aa602c74c479ecc73"
    sha256 cellar: :any,                 arm64_sequoia: "465e6299e30e75bbae4b8532311daeaed79c693a4108c0af84bc2e6854d8dd59"
    sha256 cellar: :any,                 arm64_sonoma:  "db699046d18a6d2b9ad48f7119ffdafcdddb4c298793e2d625164279b336fe0f"
    sha256 cellar: :any,                 arm64_ventura: "c0bda54defeb5ebc244a1b9088e507ff48dee169d32d9ad08a80c4e4cde6d904"
    sha256 cellar: :any,                 sonoma:        "da34e2326c5339717bda310f989e70d696858a31852ff892101e56d6d9781144"
    sha256 cellar: :any,                 ventura:       "8868cd44a2ff7f56d30c75bfba3f3d1f03c56b5faded21f69f86f93bffd1b331"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b12d1cddc16374cfbb0be45749aace3e1c1e6f623b300e593b99b97d827fbbf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c846cd2826dff13817d7dac553ebc7adbd9d992f852ee9c2c4b3540fc8f017eb"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "gnupg"
  depends_on "gpgme"
  depends_on "libgpg-error"
  depends_on "libxcb"

  def install
    system "cargo", "install", *std_cargo_args

    ENV["OUT_DIR"] = buildpath
    system bin/"gpg-tui-completions"
    bash_completion.install "gpg-tui.bash"
    fish_completion.install "gpg-tui.fish"
    zsh_completion.install "_gpg-tui"

    rm(bin/"gpg-tui-completions")
    rm(Dir[prefix/".crates*"])
  end

  test do
    require "pty"
    require "io/console"

    (testpath/"gpg-tui").mkdir
    begin
      r, w, pid = PTY.spawn bin/"gpg-tui"
      r.winsize = [80, 43]
      sleep 1
      w.write "q"
      assert_match(/^.*<.*list.*pub.*>.*$/, r.read)
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  ensure
    Process.kill("TERM", pid)
  end
end
