class Qbe < Formula
  desc "Compiler Backend"
  homepage "https://c9x.me/compile/"
  url "https://c9x.me/compile/release/qbe-1.2.tar.xz"
  sha256 "a6d50eb952525a234bf76ba151861f73b7a382ac952d985f2b9af1df5368225d"
  license "MIT"

  livecheck do
    url "https://c9x.me/compile/releases.html"
    regex(/href=.*?qbe[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "c91a5215a04c30570ccba0a0c958e748e4ffe2ea953a08721ab712c82ed022cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c3ca1c4e4642a2846dc825fa86ea27b7b4118829ce5e7c72bdf56d668c7a29ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2a90df32c350542929724a253efe4d9f5039fb3cf27364e7b08a2f6aff816d50"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8cee652f4a0941d2ffda250f8b8da61502de995ac1f84ad64aec8127b24e091e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5eff52847b1d8b30c6c56d65986801508cef2bb613c0f2c202c518c276b97cbb"
    sha256 cellar: :any_skip_relocation, sonoma:         "08b4c0f09bc6459c9439b017e60848b4cef7ae2f9c69fe9b54576b64a9c66742"
    sha256 cellar: :any_skip_relocation, ventura:        "5a74085a4f075f38f4945d760ab274c4a5e4fc059ef27f0fdecef82b8f29eafc"
    sha256 cellar: :any_skip_relocation, monterey:       "ffb1426fef8e72648b3fcc550d2dd72454cb40d82f553b75c42f16e4d91f4a23"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "fcf0274fdecef1821c3fcaed007074429d8517168f31747c1eaed904a3bb13dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56401769cc3485e1d15f4a245404068c2b2d7996e86e470904a76b77f9eae01f"
  end

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"main.ssa").write <<~EOS
      function w $add(w %a, w %b) {        # Define a function add
      @start
        %c =w add %a, %b                   # Adds the 2 arguments
        ret %c                             # Return the result
      }
      export function w $main() {          # Main function
      @start
        %r =w call $add(w 1, w 1)          # Call add(1, 1)
        call $printf(l $fmt, ..., w %r)    # Show the result
        ret 0
      }
      data $fmt = { b "One and one make %d!\n", b 0 }
    EOS

    system bin/"qbe", "-o", "out.s", "main.ssa"
    assert_path_exists testpath/"out.s"
  end
end
