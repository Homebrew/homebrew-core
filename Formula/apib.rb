class Apib < Formula
  desc "HTTP performance-testing tool"
  homepage "https://github.com/apigee/apib"
  url "https://github.com/apigee/apib/archive/APIB_1_2.tar.gz"
  sha256 "f2ed580a84ceb456ab3ca6e81c14e61b13c067dc447c65dd8f63dc0e8db15244"
  revision 1
  head "https://github.com/apigee/apib.git"

  bottle do
    cellar :any
    sha256 "89a8653925243569be382dc7a7816a836e020973e627ba0a0b3926e3de0ba684" => :catalina
    sha256 "ca59f86634b3b9282496f95b432aa9e0c9924eb189c1ec2965d427edac8bab4e" => :mojave
    sha256 "f2adc68de1b28e305ad7530ec097425bcf75beb70d6dd820f025cabcbeb54585" => :high_sierra
    sha256 "bbe9bc25a8584f163347662675d78b69cdfaac495be5f2fa026dfca112f8d4a4" => :sierra
  end

  depends_on "bazel"

  def install
    system "bazel", "build", "-c", "opt", "--copt=-O3", "//apib"
    system "bazel", "build", "-c", "opt", "--copt=-O3", "//apib:apibmon"
    bin.install "bazel-bin/apib/apib", "bazel-bin/apib/apibmon"
  end

  test do
    system "#{bin}/apib", "-c 1", "-d 1", "https://www.google.com"
  end
end
