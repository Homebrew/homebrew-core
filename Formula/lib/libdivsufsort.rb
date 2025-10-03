class Libdivsufsort < Formula
  desc "Lightweight suffix-sorting library"
  homepage "https://github.com/y-256/libdivsufsort"
  url "https://github.com/y-256/libdivsufsort/archive/refs/tags/2.0.1.tar.gz"
  sha256 "9164cb6044dcb6e430555721e3318d5a8f38871c2da9fd9256665746a69351e0"
  license "MIT"
  head "https://github.com/y-256/libdivsufsort.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "bbf20ce9184a5f8406898278ef84cc7b98fc891cbace4b6cc5a00254d7e7637b"
    sha256 cellar: :any,                 arm64_sequoia:  "e8710aed1b1bedf305651973aefa5b7b1323fb3e4fd636865974d06661c83977"
    sha256 cellar: :any,                 arm64_sonoma:   "2145e6e2de3065a7942885e0bcdb17384c0e4c52e7c946cf71df4c65f6591d04"
    sha256 cellar: :any,                 arm64_ventura:  "edc1f4556c1ca60d17bb8978df3f6e39ed61b3e0e00ba71a7361d8ca3325122d"
    sha256 cellar: :any,                 arm64_monterey: "b0e87c7f348bc9fabdcc4f5075459e6431159a820fc073925c5bc3cfd0fd93c3"
    sha256 cellar: :any,                 arm64_big_sur:  "5cb97264be66ff96dcb36dc4c243e11e0ea33ee58e4c8fa1c826c98ef11fc776"
    sha256 cellar: :any,                 sonoma:         "8e606142a047b8801fb49e7880be49a47f7638ff6a2b57ced99166a39c3ff309"
    sha256 cellar: :any,                 ventura:        "533545e33e84e9bd49a354154c4371f4c299da6f66c674fc72ce2ae77479f091"
    sha256 cellar: :any,                 monterey:       "61dfa387e2bf7536cd1e0296d54664f08e5414074166c884ab8ff8bffe7d7705"
    sha256 cellar: :any,                 big_sur:        "93a32e9897b4b9c35fa13d5d6e87ed28d1d6ba62ded97a7e31e98c62eaab1b1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "58c77deac3c2e8838698dccf6f116d21b32542b1768cabdc7fb412d330b9710e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8dd08aad6b719e629af05911116cadfa9436beb1e0231280cfd2ad9d11ff8cc4"
  end

  depends_on "cmake" => :build

  def install
    args = %w[
      -DBUILD_EXAMPLES=OFF
      -DBUILD_DIVSUFSORT64=ON
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    expected_output = <<~EOS
      SA[ 0] = 10: a$
      SA[ 1] =  7: abra$
      SA[ 2] =  0: abracadabra$
      SA[ 3] =  3: acadabra$
      SA[ 4] =  5: adabra$
      SA[ 5] =  8: bra$
      SA[ 6] =  1: bracadabra$
      SA[ 7] =  4: cadabra$
      SA[ 8] =  6: dabra$
      SA[ 9] =  9: ra$
      SA[10] =  2: racadabra$
    EOS

    ["", "64"].each do |suffix|
      (testpath/"test#{suffix}.c").write <<~C
        #include <stdio.h>
        #include <stdlib.h>
        #include <string.h>
        #include <inttypes.h>
        #include <divsufsort#{suffix}.h>

        int main() {
            char *Text = "abracadabra";
            int n = strlen(Text);
            int i, j;

            saidx#{suffix}_t *SA = (saidx#{suffix}_t *) malloc(n * sizeof(saidx#{suffix}_t));
            divsufsort#{suffix}((unsigned char *) Text, SA, n);
            for (i = 0; i < n; ++i) {
                printf("SA[%2d] = %2" #{(suffix == "64") ? "PRId64" : "PRId32"} ": ", i, SA[i]);
                for(j = SA[i]; j < n; ++j) {
                    printf("%c", Text[j]);
                }
                printf("$\\n");
            }

            free(SA);
            return 0;
        }
      C

      system ENV.cc, "test#{suffix}.c", "-I#{include}", "-L#{lib}", "-ldivsufsort#{suffix}", "-o", "test#{suffix}"
      assert_equal expected_output, shell_output(testpath/"test#{suffix}")
    end
  end
end
