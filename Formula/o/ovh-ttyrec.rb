class OvhTtyrec < Formula
  desc "Enhanced (but compatible) version of the classic ttyrec"
  homepage "https://github.com/ovh/ovh-ttyrec"
  url "https://github.com/ovh/ovh-ttyrec/archive/refs/tags/v1.2.0.0.tar.gz"
  sha256 "74a474ea33090a9a814c186429c2f725c0bfa1f9d3ceee03caf999daf047eb41"
  license all_of: ["BSD-3-Clause", "BSD-4-Clause-UC"]

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a230c45574d67b74fa0fa4bf2fb756cacebb3bc8ab83d3167db999c542e49e36"
    sha256 cellar: :any, arm64_sequoia: "20a97830384deca10281cf7ad0f23e1bfebb835a134eefcf2a279ad52cb69554"
    sha256 cellar: :any, arm64_sonoma:  "4dbe262314355b29ef3aaa4a4c22434ce9f6ad16bef5e10fe2c39d73c452cb71"
    sha256 cellar: :any, sonoma:        "a306c3d4ce9a5813ea869c351ba18a077ec99dd77fd1a2f134454fca8c60be63"
    sha256 cellar: :any, arm64_linux:   "a05d2af513ccc1705cc444442998940c77f8ebc205d5d279bcdca193a3b9c30b"
    sha256 cellar: :any, x86_64_linux:  "fb32053d1909df6d7b2f6e7deb847dff5ee1028cb9018ee7356923fdcb6d5d38"
  end

  depends_on "zstd"

  conflicts_with "ttyrec", because: "both install the same binaries"

  def install
    ENV["NO_STATIC_ZSTD"] = "1"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.tty").binwrite([0, 0, 4].pack("V3") + "test" + [9, 0, 3].pack("V3") + "end")

    assert_equal "9\ttest.tty", shell_output("#{bin}/ttytime test.tty").strip
  end
end
