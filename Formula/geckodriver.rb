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
    rebuild 1
    sha256 "579bc00a6c39dac983705426453104099af036f6f0651e50a49cb25e4a52a60c" => :high_sierra
    sha256 "c7523715a1f1610051bafd47861976da1ccbc4a2203e0df263c52426d3bebe00" => :sierra
    sha256 "9688a792640220274fdf61b87cc4bb1135c2a4d35c2f627b6bd859f5674152ac" => :el_capitan
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
