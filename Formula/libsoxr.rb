class Libsoxr < Formula
  desc "High quality, one-dimensional sample-rate conversion library"
  homepage "https://sourceforge.net/projects/soxr/"
  url "https://downloads.sourceforge.net/project/soxr/soxr-0.1.3-Source.tar.xz"
  sha256 "b111c15fdc8c029989330ff559184198c161100a59312f5dc19ddeb9b5a15889"

  bottle do
    cellar :any
    sha256 "1cf9d077581bf9b8a720a68f958d7770f3daabf48d27dfcc9b0e149ea747382a" => :high_sierra
    sha256 "7905cfa192a904822758779d1bca29bb54dd27fc91c3d49e2e49ee6bea55e273" => :sierra
    sha256 "077ef8de96bc1d6e91c102a1ef37a8abdfc5a5c58e630ddf4c71d588f4928514" => :el_capitan
    sha256 "b4a93f140c6811066af0a9c4ed5018426cacd57708aeed413b81ff887823926e" => :yosemite
    sha256 "ab97e9c831858081a06933a5394623b8e4dbafd660e507cfbe851dee07c73c09" => :mavericks
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
