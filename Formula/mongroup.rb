class Mongroup < Formula
  desc "Monitor a group of processes with mon"
  homepage "https://github.com/jgallen23/mongroup"
  url "https://github.com/jgallen23/mongroup/archive/0.4.1.tar.gz"
  sha256 "50c6fb0eb6880fa837238a2036f9bc77d2f6db8c66b8c9a041479e2771a925ae"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "57c107a2746fae7e9db832f54df3d5170449defc30334094939794288659f026" => :catalina
    sha256 "4c11751013bae001ff2dcf55c3566613e83fe0d9257e0691c9da7b2aec298918" => :mojave
    sha256 "230996b629ff1a72b405ba6c7fbb8cdd0fd06292b16bacf124bc2e30c5f9917e" => :high_sierra
    sha256 "d3065cb969df510f29b742e1d6606151328af2afe3542bb3ff3462e7551ade9b" => :sierra
    sha256 "8e801dac08ad7a776d698dc8bfc170f1df2fcb621561b86c789cc0e8098b1b38" => :el_capitan
    sha256 "f7db89622f5575404e2ccbb1d0aca159f06b82766f27ac28bd41492d498128a7" => :mavericks
  end

  depends_on "mon"

  def install
    bin.mkpath
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system "#{bin}/mongroup", "-V"
  end
end
