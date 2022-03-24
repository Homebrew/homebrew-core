class Goimapnotify < Formula
  desc "Execute scripts on IMAP mailbox changes using IDLE, golang version"
  homepage "https://gitlab.com/shackra/goimapnotify"
  url "https://gitlab.com/shackra/goimapnotify/-/archive/2.3.7/goimapnotify-2.3.7.tar.bz2"
  sha256 "f927732ac4307d0671f3015af6f69cab5e5c82e57fe1374201947f0187214c1c"
  license "GPL-3.0-only"
  head "https://gitlab.com/shackra/goimapnotify.git", branch: "master"

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    bin_path = buildpath/"src/github.com/shackra/goimapnotify"
    bin_path.install Dir["*"]

    cd bin_path do
      system "go", "build", "-o", bin/"goimapnotify", "."
    end
  end

  test do
    assert_match(/^Usage of .*?goimapnotify/, shell_output("#{bin}/goimapnotify -h 2>&1"))
  end
end
