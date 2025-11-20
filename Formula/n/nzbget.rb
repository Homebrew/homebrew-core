class Nzbget < Formula
  desc "Binary newsgrabber for nzb files"
  homepage "https://nzbget.com"
  url "https://github.com/nzbgetcom/nzbget/archive/refs/tags/v25.4.tar.gz"
  sha256 "2603116ffaef4992621cf7a82ce300f41a676a312de784f2bac5058abc1a2385"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/nzbgetcom/nzbget.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d58d5e02c13187de9e65cd6d35120b1611433af868cf679671dd88857a388a91"
    sha256 cellar: :any,                 arm64_sequoia: "557f35ed33c1b601a460529ee647920add29173737393db95b1ce162b9105df4"
    sha256 cellar: :any,                 arm64_sonoma:  "5f500e14b4eb1daa87f1ecd30acd5975f070518fc80068c696163fd1a5fbc560"
    sha256                               sonoma:        "c6eefaf0b485757b8557105179aed95b178423fab5aaa42f783408e6c614df4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc9d8d51be52ecdde34f047d3b6dc171596305e911d7926f858341add9415c8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f841f60ac2ac0a4e8b23ac2b4cd837fe6be993c8f46e538be7e744c328e4a7e9"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "openssl@3"
  depends_on "sevenzip"

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    inreplace "nzbget.conf" do |s|
      if OS.mac?
        # Set upstream's recommended values for file systems without
        # sparse-file support (e.g., HFS+); see Homebrew/homebrew-core#972
        s.gsub! "DirectWrite=yes", "DirectWrite=no"
        s.gsub! "ArticleCache=0", "ArticleCache=700"
      end

      # Update 7z cmd to match homebrew binary
      s.gsub! "SevenZipCmd=7z", "SevenZipCmd=7zz"
    end

    etc.install "nzbget.conf"
  end

  service do
    run [opt_bin/"nzbget", "-c", HOMEBREW_PREFIX/"etc/nzbget.conf", "-s", "-o", "OutputMode=Log",
         "-o", "ConfigTemplate=#{HOMEBREW_PREFIX}/share/nzbget/nzbget.conf",
         "-o", "WebDir=#{HOMEBREW_PREFIX}/share/nzbget/webui"]
    keep_alive true
    environment_variables PATH: "#{HOMEBREW_PREFIX}/bin:/usr/bin:/bin:/usr/sbin:/sbin"
  end

  test do
    (testpath/"downloads/dst").mkpath
    # Start nzbget as a server in daemon-mode
    system bin/"nzbget", "-D", "-c", etc/"nzbget.conf"
    # Query server for version information
    system bin/"nzbget", "-V", "-c", etc/"nzbget.conf"
    # Shutdown server daemon
    system bin/"nzbget", "-Q", "-c", etc/"nzbget.conf"
  end
end
