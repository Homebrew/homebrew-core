class Mafft < Formula
  desc "Multiple alignments with fast Fourier transforms"
  homepage "https://mafft.cbrc.jp/alignment/software/"
  url "https://gitlab.com/sysimm/mafft.git",
      tag:      "v7.525",
      revision: "a1e1e3f1bd468b0e47918840c7b82057f0fd1faa"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/The latest version is (\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "256ec7b1ed45a40135d2b4ca03c9d108a84177a85f8b119f2209188309766f65"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "219e442bf7af3df694fe8db914e6028b9e11d0bf5c314446373156a686e2ec3e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06cdd139defbac1ef1ac3e0021f4e0e889145f4a84d97e504c0e82a555a1a5a2"
    sha256 cellar: :any_skip_relocation, sonoma:         "2a6e523ad86aa8db7212ddd47ca5193df7e3409465836d6c3749004c184e3cd4"
    sha256 cellar: :any_skip_relocation, ventura:        "010b2bd3a37895feb8a2effbe47a35711786394f78cda4292613ff0ba6b99fe6"
    sha256 cellar: :any_skip_relocation, monterey:       "4f238aae0d4e8404f247e79134a70fdc80e3b31c5acca1cfd002d07b10b85d09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c44ff19df4e8f79b5ceb8c6cf29f064fd2bdcd11654af87b1f9475b25f90ee2"
  end

  def install
    make_args = %W[CC=#{ENV.cc} CXX=#{ENV.cxx} PREFIX=#{prefix} install]
    system "make", "-C", "core", *make_args
    system "make", "-C", "extensions", *make_args
  end

  test do
    (testpath/"test.fa").write ">1\nA\n>2\nA"
    output = shell_output("#{bin}/mafft test.fa")
    assert_match ">1\na\n>2\na", output
  end
end
