class Goofys < Formula
  desc "Filey-System interface to Amazon S3"
  homepage "https://github.com/kahing/goofys"
  url "https://github.com/kahing/goofys.git",
      tag:      "v0.24.0",
      revision: "45b8d78375af1b24604439d2e60c567654bcdf88"
  license "Apache-2.0"
  head "https://github.com/kahing/goofys.git"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, catalina:     "da054592343f7423d91a3abadbe4d601295b1f74b3a404c36fdb4deb94f7019b"
    sha256 cellar: :any_skip_relocation, mojave:       "cee50248f9ac4d33ef8ca585ad94e3c9e6226fc464dfad86de2b7f9497b9f2b7"
    sha256 cellar: :any_skip_relocation, high_sierra:  "eb0a3cfe49104292c16d76dce71db34000b1a7214f660b3cff3a39e4b3ba7a44"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "53acc931a935c3e7c6230a59d492bf0cea7238167415083232d6ef37741b1cdc"
  end

  depends_on "go" => :build

  on_macos do
    disable! date: "2021-04-08", because: "requires closed-source macFUSE"
  end

  on_linux do
    depends_on "libfuse"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath/"src/github.com/kahing/goofys").install buildpath.children

    cd "src/github.com/kahing/goofys" do
      system "go", "build", "-o", "goofys", "-ldflags", "-X main.Version=#{Utils.git_head}"
      bin.install "goofys"
      prefix.install_metafiles
    end
  end

  def caveats
    on_macos do
      <<~EOS
        The reasons for disabling this formula can be found here:
          https://github.com/Homebrew/homebrew-core/pull/64491

        An external tap may provide a replacement formula. See:
          https://docs.brew.sh/Interesting-Taps-and-Forks
      EOS
    end
  end

  test do
    system bin/"goofys", "--version"
  end
end
