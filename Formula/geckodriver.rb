class Geckodriver < Formula
  desc "WebDriver <-> Marionette proxy"
  homepage "https://github.com/mozilla/geckodriver"
  head "https://hg.mozilla.org/mozilla-central/", :using => :hg

  stable do
    url "https://github.com/mozilla/geckodriver/archive/v0.19.1.tar.gz"
    sha256 "f590ddfef42995a23e781b52befdbc2ac342bf829008e98d212f2e1e15d9f713"

    # Remove for > 0.19.1
    # Fixes E0277 when building slog with Rust > 1.23
    # Fixed upstream in https://hg.mozilla.org/mozilla-central/rev/cbd3741a4bb0 on 2018-02-15.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/e89f1ad/geckodriver/bug-1435830.patch"
      sha256 "578cdb22803c2f6ee00e8e0b1ca6fcde622c743572aad7038dda0d63cbce4500"
    end
  end

  bottle do
    sha256 "469b6c642b0029195c94eacf68cc4b8d90a51fcd39f1c6eee7a38b74face0f35" => :high_sierra
    sha256 "fe98e37bfc14be0a4acf84ced1149ad410684c9235060f2560d256b0cf4e4bbe" => :sierra
    sha256 "368b38b2b40cced77457a3fa47369f6668549df2fe84fd80c6926964ea55dcbc" => :el_capitan
  end

  depends_on "rust" => :build

  def install
    dir = build.head? ? "testing/geckodriver" : "."
    cd(dir) { system "cargo", "build" }
    bin.install "target/debug/geckodriver"
    bin.install_symlink bin/"geckodriver" => "wires"
  end

  test do
    system bin/"geckodriver", "--help"
  end
end
