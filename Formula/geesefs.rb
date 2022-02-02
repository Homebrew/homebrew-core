class Geesefs < Formula
  desc "Finally, a good FUSE FS implementation over S3"
  homepage "https://github.com/yandex-cloud/geesefs"
  url "https://github.com/yandex-cloud/geesefs/archive/refs/heads/master.tar.gz"
  sha256 "e6578adaffe47f9bf954847a79392b73ef118dc44a564e5d9bf61f5c8c509ce5"

  license "Apache-2.0"

  depends_on "go" => :build

  # For tests
  depends_on "bash" => :build
  depends_on "python@3.10" => :build
  depends_on "truncate" => :build
  depends_on "openjdk" => :build

  def install
    system "go", "build", "-o", "#{bin}/geesefs"
  end

  test do
    system "make", "run-test"
  end
end
