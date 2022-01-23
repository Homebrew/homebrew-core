class Goimapnotify < Formula
  desc "Execute scripts on IMAP mailbox changes using IDLE, golang version"
  homepage "https://gitlab.com/shackra/goimapnotify"
  license "GPL-3.0-only"
  head "https://gitlab.com/shackra/goimapnotify.git",
    tag: "2.4-rc1", revision: "97de8c15c48cdd3c6d9570a65d714a635b822642"

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
    assert_match "Usage of goimapnotify", shell_output("#{bin}/goimapnotify 2>&1")
  end
end
