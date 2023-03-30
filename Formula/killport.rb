class Killport < Formula
  desc "A command-line tool to kill processes listening on a specific port"
  homepage "https://github.com/jkfran/killport"
  version "0.6.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.intel?
      url "#{homepage}/releases/download/v#{version}/killport-x86_64-apple-darwin.tar.gz"
      sha256 "e038ab43207a95702ad31719bf98abfd5b0c39e276ef45230722fbc916db69bd"
    elsif Hardware::CPU.arm?
      url "#{homepage}/releases/download/v#{version}/killport-aarch64-apple-darwin.tar.gz"
      sha256 "b31402afc2e59b1483a80c2ba1692a41ea4642c9f0d1c6a5c5b80e9e66c9bbae"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "#{homepage}/releases/download/v#{version}/killport-x86_64-linux-gnu.tar.gz"
      sha256 "0288bb11a1e141b0fc0b1e48124e2f560769cc9fe3efff430350456b7cd8310b"
    elsif Hardware::CPU.arm?
      url "#{homepage}/releases/download/v#{version}/killport-aarch64-linux-gnu.tar.gz"
      sha256 "86930d0387efcdc1c5b4bccd9f1f0869eec100adc1aa82ae12c6f1a15003d34b"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      if Hardware::CPU.is_64_bit?
        url "#{homepage}/releases/download/v#{version}/killport-x86_64-linux-gnu.tar.gz"
        sha256 "0288bb11a1e141b0fc0b1e48124e2f560769cc9fe3efff430350456b7cd8310b"
      elsif Hardware::CPU.is_32_bit?
        url "#{homepage}/releases/download/v#{version}/killport-i686-linux-gnu.tar.gz"
        sha256 "64048d6db6c29b23fcdcab3fb999571f0ef45ea4738c373f812730cd1f070d02"
      else
        odie "Error: Unsupported Intel architecture."
      end
    elsif Hardware::CPU.arm?
      if Hardware::CPU.arch == :armv7
        url "#{homepage}/releases/download/v#{version}/killport-armv7-linux-gnueabihf.tar.gz"
        sha256 "114eda61639a688ab985f3eb28dc49c806ab29f4cdd2db3e5c5361f411c0ff86"
      elsif Hardware::CPU.is_32_bit?
        url "#{homepage}/releases/download/v#{version}/killport-arm-linux-gnueabihf.tar.gz"
        sha256 "10046beb283ddae718a0c90dd8be960d41ed843a6d0ff3f6fadb650317dccadd"
      elsif Hardware::CPU.is_64_bit?
        url "#{homepage}/releases/download/v#{version}/killport-aarch64-linux-gnu.tar.gz"
        sha256 "86930d0387efcdc1c5b4bccd9f1f0869eec100adc1aa82ae12c6f1a15003d34b"
      else
        odie "Error: Unsupported ARM architecture."
      end
    elsif Hardware::CPU.ppc64le?
      url "#{homepage}/releases/download/v#{version}/killport-powerpc64le-linux-gnu.tar.gz"
      sha256 "e6cf8e159d978045109f9e8e5fea3d864bec762ac435b94e9882b01db30d5d7c"
    elsif Hardware::CPU.s390x?
      url "#{homepage}/releases/download/v#{version}/killport-s390x-linux-gnu.tar.gz"
      sha256 "e421bec3ee6466c2ce4adf2af4fb719c6eee344fb96f88fdce208f9a0f749a03"
    else
      odie "Error: Unsupported architecture: #{Hardware::CPU.arch}"
    end
  end

  def install
    bin.install "killport"
  end

  test do
    system "#{bin}/killport", "--version"
  end
end

