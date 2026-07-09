class Qbe < Formula
  desc "Compiler Backend"
  homepage "https://c9x.me/compile/"
  url "https://c9x.me/compile/release/qbe-1.3.tar.xz"
  sha256 "d587905d620dc5e1d2bfa7c2cc642b9b837aa89a3188c6e37b53d756cf66e320"
  license "MIT"
  head "git://c9x.me/qbe.git", branch: "master"

  livecheck do
    url "https://c9x.me/compile/releases.html"
    regex(/href=.*?qbe[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8868313b295b2c971c8bff621de5aadf80564ce87d071ce10e7b5cf6a3ad8b0e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6145d25ff89c0d21b2d1f5bf4dae9ad7e88718f72b911a37ea2cbde23580e262"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "98f82cab4d973bfc300e62f3fa7faa43dd4a2cf0e190381f1a14810d9b085996"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c38dbe7d28d40a1553ce4f52522a3c73eb4b856a19a4a5ee74e1aad2c15932c"
    sha256 cellar: :any,                 arm64_linux:   "3674c11520dacc5363910d836a27109ca2106bb1e7614c355428d0d7dcfa371b"
    sha256 cellar: :any,                 x86_64_linux:  "86d66c1c3bf1ffcec7072c3c41f48bbbb8bd8ed5ffa1ab102cd33d35c12d7152"
  end

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"main.ssa").write <<~SSA
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
    SSA

    system bin/"qbe", "-o", "out.s", "main.ssa"
    assert_path_exists testpath/"out.s"
  end
end
