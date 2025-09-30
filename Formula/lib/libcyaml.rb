class Libcyaml < Formula
  desc "C library for reading and writing YAML"
  homepage "https://github.com/tlsa/libcyaml"
  url "https://github.com/tlsa/libcyaml/archive/refs/tags/v1.4.2.tar.gz"
  sha256 "3211b2a0589ebfe02c563c96adce9246c0787be2af30353becbbd362998d16dc"
  license "ISC"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "4c43a46d9a87bcc3cfde22e5eb1ad104e3d17092933034b61af0ed87a048bc31"
    sha256 cellar: :any,                 arm64_sequoia:  "326caffc3d633d21af0cb1c24096ada03d9d485b2d089b9214b96db7951e5dea"
    sha256 cellar: :any,                 arm64_sonoma:   "a9147c54f5f0996413c8ae21ad22549d6ebdd3271fcd72c9e4e73c80f4db8067"
    sha256 cellar: :any,                 arm64_ventura:  "b3cf670ef44d98d11d9d9d84faeb1ebcf48bbc109ba6ab6b3e96b7297bed015e"
    sha256 cellar: :any,                 arm64_monterey: "a87c89eb5de04774d6ac71b0934791c3040c4f326b6f51f4e1717ce5bfa1a64a"
    sha256 cellar: :any,                 sonoma:         "1c92fa081bb054a3f92a8c37b3bf9c6504240c7a06935c3661aaf7b1afdfd2e1"
    sha256 cellar: :any,                 ventura:        "d04c058836bbd8fe0cac928c000836884c80f7ded2f3addfbb66e3b63030e644"
    sha256 cellar: :any,                 monterey:       "4b56dac4eca00856bd125610014ef2ed230bda981e910a37ee67118874b85219"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "a4deac758411695b4c3a5c1b9860d3098d38ac10040bcfd920ca6022f21f6b6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9941417c37c0d014a1ca1bf23c83275c5f36e5edbd75c320c4f0124d6964b87b"
  end

  depends_on "libyaml"

  def install
    system "make", "install", "PREFIX=#{prefix}"
    pkgshare.install "examples/numerical/main.c" => "test.c"
  end

  test do
    flags = %W[
      -I#{include} -I#{Formula["libyaml"].opt_include}
      -L#{lib} -L#{Formula["libyaml"].opt_lib}
      -lcyaml -lyaml
      -o test
    ]

    system ENV.cc, pkgshare/"test.c", *flags

    (testpath/"test.yaml").write "name: Numbers\ndata:\n- 1\n- 2\n- 4\n- 8\n"
    expected_output = "Numbers:\n  - 1\n  - 2\n  - 4\n  - 8\n"
    assert_equal expected_output, shell_output("#{testpath}/test #{testpath}/test.yaml")
  end
end
