class Libpipeline < Formula
  desc "C library for manipulating pipelines of subprocesses"
  homepage "https://libpipeline.gitlab.io/libpipeline/"
  url "https://download.savannah.nongnu.org/releases/libpipeline/libpipeline-1.5.8.tar.gz"
  sha256 "1b1203ca152ccd63983c3f2112f7fe6fa5afd453218ede5153d1b31e11bb8405"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://download.savannah.nongnu.org/releases/libpipeline/"
    regex(/href=.*?libpipeline[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "3123efab5271d992b2d9aaf9a40465e7ff0dad00904eaa590bae9fbf6f4b4ddf"
    sha256 cellar: :any,                 arm64_sequoia:  "f67581fe73ae3c61a464f81517ad552826b5fa3583c5c6eb03f3da49cf514aee"
    sha256 cellar: :any,                 arm64_sonoma:   "4b787bff3015387a503f742b68c364dad56e0af8d31a6a8935223bc65aad6015"
    sha256 cellar: :any,                 arm64_ventura:  "0cc8c97d57a3b87b05aae33064e6c0da47423dc55b805045d867ef066e811911"
    sha256 cellar: :any,                 arm64_monterey: "b28d5147cafc83783181d99cc612056d062b5e15a90543351043af3afda40879"
    sha256 cellar: :any,                 sonoma:         "e0354d5f278901871e1fc4ba62668680a1c80fe90bd9f3345206e5e5ea798b71"
    sha256 cellar: :any,                 ventura:        "a1f870458e27abf80d1664aea510dbb59cf38b330a94253050c9ef17b2d2b7bd"
    sha256 cellar: :any,                 monterey:       "ae49773c27c293203ce8e82194ee64edf81aace1b517029698f0a104cb82d878"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "d40093ecab1d13a45f12170a96c80d878d3b273ca0f0f0e9d9d684f4ced5299a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9767e66d73f174a20b3ea560643f30e3bb3e2b5764c0fc5de4196247e13feee"
  end

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <pipeline.h>
      int main() {
        pipeline *p = pipeline_new();
        pipeline_command_args(p, "echo", "Hello world", NULL);
        pipeline_command_args(p, "cat", NULL);
        return pipeline_run(p);
      }
    C
    system ENV.cc, "-I#{include}", "test.c", "-L#{lib}", "-lpipeline", "-o", "test"
    assert_match "Hello world", shell_output("./test")
  end
end
