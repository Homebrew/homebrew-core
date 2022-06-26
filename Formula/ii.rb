class Ii < Formula
  desc "Minimalist IRC client"
  homepage "https://tools.suckless.org/ii/"
  url "https://dl.suckless.org/tools/ii-1.9.tar.gz"
  sha256 "850cb323b583d261b51bda9993ee733334352a8e6ca1e2f02b57c154bf568c17"
  license "MIT"
  head "https://git.suckless.org/ii", using: :git, branch: "master"

  livecheck do
    url "https://dl.suckless.org/tools/"
    regex(/href=.*?ii[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0300f524271b1dda6684b35ed4b15e532ef75ccc64a9b23299ec9f1bda14307f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a6c755033afefd3157a99c07be5b901c8b6c16043fbffca79db6dbbb4d317125"
    sha256 cellar: :any_skip_relocation, monterey:       "c686540cf1e05a9e6af37bbd128d845d2348392c6f7e20176d068ee8ed50a1b3"
    sha256 cellar: :any_skip_relocation, big_sur:        "2df8591a79a05357b25a2c83ad9da2c2f0e58260e04cfbae584301f4173f7949"
    sha256 cellar: :any_skip_relocation, catalina:       "24860645a705891e28753b62ce7338764d6f46310e79756df3626c703fc196ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71a077a04a5c61a79083459e659d252920c24661edbeeb6c8248914aac1931d1"
  end

  def install
    # macOS already provides strlcpy
    if OS.mac?
      inreplace "config.mk" do |s|
        s.gsub! "= -DNEED_STRLCPY -Os", "= -Os"
        s.gsub! "= strlcpy.o", "="
      end
    end

    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    port = free_port
    output = shell_output("#{bin}/ii -s localhost -p #{port} 2>&1", 1)
    assert_match "#{bin}/ii: could not connect to localhost:#{port}:", output.chomp
  end
end
