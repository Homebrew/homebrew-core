class ArgpStandalone < Formula
  desc "Standalone version of arguments parsing functions from GLIBC"
  homepage "https://github.com/argp-standalone/argp-standalone"
  url "https://github.com/argp-standalone/argp-standalone/archive/refs/tags/1.5.0.tar.gz"
  sha256 "c29eae929dfebd575c38174f2c8c315766092cec99a8f987569d0cad3c6d64f6"
  license all_of: [
    "LGPL-2.1-or-later",
    "LGPL-2.0-or-later", # argp.h, argp-parse.c
    :public_domain,      # mempcpy.c, strchrnul.c
  ]

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "4e16dcc9c857334ef0c9edee97b5063ead0f3f8dddc428ccb9cbeec6881a104c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "b71de47f10a604629ded46675494d28ec5189153afe353425a4f6f52ab879f29"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ded4333901f512960d2087fd1177a70c82af78f296d858e517b52d94a2585520"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f24ae027fbc894e59972455cf569fd3676dc90d87ab93e4919df9fce0698ec1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "52318bf7231650f9e0a5f956ee4ec133e34355d15c137267c6dbbc27f426d080"
    sha256 cellar: :any_skip_relocation, sonoma:         "4fa315b100b5d38eb5bf4c8fdaff61075c58f78a029434ccb1e9beb32c44c640"
    sha256 cellar: :any_skip_relocation, ventura:        "e274c57f48b316cfbd5fd3d13f560d85f9e62ae1cc44483565ddd73d90d31a21"
    sha256 cellar: :any_skip_relocation, monterey:       "207d701bc2983741c8bbe79297945eb4982ad58ba5597557d3216aa99e90a543"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on :macos # argp is provided by glibc on Linux

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <argp.h>

      int main(int argc, char ** argv)
      {
        return argp_parse(0, argc, argv, 0, 0, 0);
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-largp", "-o", "test"
    system "./test"
  end
end
