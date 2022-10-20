class FdkAacEncoder < Formula
  desc "Command-line encoder frontend for libfdk-aac"
  homepage "https://github.com/nu774/fdkaac"
  url "https://github.com/nu774/fdkaac/archive/v1.0.3.tar.gz"
  sha256 "ee444518353833b2b8f1b106bb4d9e9c15ae4d48569be9b6c89fc38dabf364b7"
  license "Zlib"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "bef622b7d5d4026b6d8615f6a747bcf0128826cfabe9bbe3cce6c0cd139591b9"
    sha256 cellar: :any,                 arm64_big_sur:  "dd84a279e61d463b1651f1bc2c4fef060f6bc0059cf25c798a2161123cf1368b"
    sha256 cellar: :any,                 monterey:       "9903add3d37f84fd89d0ba40c8f719a093126dbe5f47c4639c3399109fb855e1"
    sha256 cellar: :any,                 big_sur:        "f9103b8b675603ca90b3e7f4efb0074a1452e9852d1a1659d2f59a5a025a8c83"
    sha256 cellar: :any,                 catalina:       "6de255d18252acbcc3e0b8214b9eb46c3c4d2a29b46e6cc15bc7cbc81cd61115"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e40141a65ef6f0c04974df102db68f08866701c9b2e018efcb2c11e84253174f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "fdk-aac"

  def install
    system "autoreconf", "-i"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    # generate test tone pcm file
    sample_rate = 44100
    two_pi = 2 * Math::PI

    num_samples = sample_rate
    frequency = 440.0
    max_amplitude = 0.2

    position_in_period = 0.0
    position_in_period_delta = frequency / sample_rate

    samples = [].fill(0.0, 0, num_samples)

    num_samples.times do |i|
      samples[i] = Math.sin(position_in_period * two_pi) * max_amplitude

      position_in_period += position_in_period_delta

      position_in_period -= 1.0 if position_in_period >= 1.0
    end

    samples.map! do |sample|
      (sample * 32767.0).round
    end

    File.open("#{testpath}/tone.pcm", "wb") do |f|
      f.syswrite(samples.flatten.pack("s*"))
    end

    system "#{bin}/fdkaac", "-R", "--raw-channels", "1", "-m",
           "1", "#{testpath}/tone.pcm", "--title", "Test Tone"
  end
end
