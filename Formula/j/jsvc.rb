class Jsvc < Formula
  desc "Wrapper to launch Java applications as daemons"
  homepage "https://commons.apache.org/daemon/jsvc.html"
  url "https://www.apache.org/dyn/closer.lua?path=commons/daemon/source/commons-daemon-1.4.0-src.tar.gz"
  mirror "https://archive.apache.org/dist/commons/daemon/source/commons-daemon-1.4.0-src.tar.gz"
  sha256 "0059f1e80aa639f02c7e1ff800b57dc62036a5b3f4b17d61e5d3e3ffd2428fee"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0749b79fd00320427bac85b639dcf2349f005b17cb3ce673289fc059cb96b685"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "da8011ddc9b79a39530d7f5c14b6ca044c5a1fb1811adc52a0bb4fb399a58dd1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "252dedd105372cc567919abb4a076feb4b47ecb55babafad8fa8c96499ab2769"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "560dad0bc6f713b936aea6cf9e26043cfcfae79488f71f9f5cde0b8e3cbd3900"
    sha256 cellar: :any_skip_relocation, sonoma:         "5e02dfd1ddb83a236cae975a5452764909fba6c5424d6b4569a701c1a8396af8"
    sha256 cellar: :any_skip_relocation, ventura:        "6c188b4235704997a056da7a68de92a1d9013d4a7415b98baae0870dc64debd5"
    sha256 cellar: :any_skip_relocation, monterey:       "b22e2638c3e59970a1eaacc4468ee83d438a6010cf411591034c1ba623ef8d0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e4b2cb1e48a600781869d4007377c3a6e3287a2ac58eba3c6c37a344df34d8c"
  end

  depends_on "openjdk@21"

  def install
    prefix.install %w[NOTICE.txt LICENSE.txt RELEASE-NOTES.txt]

    cd "src/native/unix" do
      # https://github.com/Homebrew/homebrew-core/pull/168294#issuecomment-2104388230
      ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

      system "./configure", "--with-java=#{Formula["openjdk@21"].opt_prefix}"
      system "make"

      libexec.install "jsvc"
      (bin/"jsvc").write_env_script libexec/"jsvc", Language::Java.overridable_java_home_env("21")
    end
  end

  test do
    output = shell_output("#{bin}/jsvc -help")
    assert_match "jsvc (Apache Commons Daemon)", output
  end
end
