class Noti < Formula
  desc "Trigger notifications when a process completes"
  homepage "https://github.com/variadico/noti"
  url "https://github.com/variadico/noti/archive/3.1.0.tar.gz"
  sha256 "3210059aefb9dbbefc67948518509eb2800209fe61bceb158360931dc8d2bd32"

  bottle do
    cellar :any_skip_relocation
    sha256 "472aa21bb739b064f79f2b7aed61ec699b1aa7ae9d239baef7947fa72817b583" => :mojave
    sha256 "2ce04f2a8cf722016935a83010314a08a0bb0d9ca7aeed7b62dd9ceab4b73cda" => :high_sierra
    sha256 "72d72841b3a4f488014abe42d27913c8d9049f681851e4abde30a4a8b2e64554" => :sierra
    sha256 "72b5fa9563eaf47e3f25f7792bcd9500fb71432932aa4840af70c81c936b94c1" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    notipath = buildpath/"src/github.com/variadico/noti"
    notipath.install Dir["*"]

    cd "src/github.com/variadico/noti/cmd/noti" do
      system "go", "build"
      bin.install "noti"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/noti", "-t", "Noti", "-m", "'Noti recipe installation test has finished.'"
  end
end
