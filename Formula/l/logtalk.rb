class Logtalk < Formula
  desc "Declarative object-oriented logic programming language"
  homepage "https://logtalk.org/"
  url "https://github.com/LogtalkDotOrg/logtalk3/archive/refs/tags/lgt3930stable.tar.gz"
  version "3.93.0"
  sha256 "6b8ac9a74bd7be7d28a52580572ed11dd22b9323eadf927695f5f0afea13d315"
  license "Apache-2.0"
  head "https://github.com/LogtalkDotOrg/logtalk3.git", branch: "master"

  livecheck do
    url "https://logtalk.org/download.html"
    regex(/Latest stable version:.*?v?(\d+(?:\.\d+)+)/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13aaa9aed141c81da8de20352961a1bfc5e216cb1d7bd01674d8fad1ba74cf50"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ce4655791574c9fc71512b7a59068b12ad4c6c585f001a7e5c01bda3c9255bef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca3e2ee195a90b2d2f045824e0a42d11104365a35d03ed5b885ff2e078559638"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ca3e2ee195a90b2d2f045824e0a42d11104365a35d03ed5b885ff2e078559638"
    sha256 cellar: :any_skip_relocation, sonoma:        "38b47b0804589535c0cafcf941ebe0b0621490ded7b6663d9220b8a8b2a99b69"
    sha256 cellar: :any_skip_relocation, ventura:       "35f9e7d0aea550e2149a44d5d3e89c7cd17d76ca2c8d50e6255bc1245ab44a62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1378970921e3f26eba86554a7dc0b566583eb18d0f21c751b7a8ee22196d18b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "058f13466191bb1d14d4fd45723fa054de5c0a7351d922b3155082eef23adb3b"
  end

  depends_on "gnu-prolog"

  def install
    system "./scripts/install.sh", "-p", prefix

    # Resolve relative symlinks for env script
    bin.each_child do |f|
      next unless f.symlink?

      realpath = f.realpath
      f.unlink
      ln_s realpath, f
    end
    bin.env_script_all_files libexec/"bin", LOGTALKHOME: HOMEBREW_PREFIX/"share/logtalk",
                                            LOGTALKUSER: "${LOGTALKUSER:-$HOME/logtalk}"
  end

  def caveats
    <<~EOS
      Logtalk has been configured with the following environment variables:
        LOGTALKHOME=#{HOMEBREW_PREFIX}/share/logtalk
        LOGTALKUSER=$HOME/logtalk
    EOS
  end

  test do
    output = pipe_output("#{bin}/gplgt 2>&1", "logtalk_load(hello_world(loader)).")
    assert_match "Hello World!", output
    refute_match "LOGTALKUSER should be defined first", output
  end
end
