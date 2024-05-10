class Libcyaml < Formula
  desc "C library for reading and writing YAML"
  homepage "https://github.com/tlsa/libcyaml"
  url "https://github.com/tlsa/libcyaml/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "8dbd216e1fce90f9f7cca341e5178710adc76ee360a7793ef867edb28f3e4130"
  license "ISC"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7665135d5a866530f02d8d81ae583923323a57bd842f84b70959c423fc0f4fa6"
    sha256 cellar: :any,                 arm64_ventura:  "15bfb3365a9b5b01df499161e3d00ab6feb75ae716386d2e96e5a3582eb43544"
    sha256 cellar: :any,                 arm64_monterey: "a886fc1f230ed6d8dbc1b423f09be7d9a97f5948bfadefe0597bf65c84f4fd53"
    sha256 cellar: :any,                 sonoma:         "7c060c32a2e0dab29a14416727c7a95807100bcc9f2566dfb8a02539e0706fa9"
    sha256 cellar: :any,                 ventura:        "7853a806c80ee93b6ebdfe815f7cf026b9699aae045eff71802cbd646985d47d"
    sha256 cellar: :any,                 monterey:       "75224fb2a779e38d5cc0f6f18fb90a7c74822fda59a5365a8ced9fbe6abc0279"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee3f4fd485e3c10463b86713be65b46eb2f53b98c5fe25edb00607d94131e2e7"
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
