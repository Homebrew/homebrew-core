class Mairix < Formula
  desc "Email index and search tool"
  homepage "https://github.com/vandry/mairix"
  url "https://github.com/vandry/mairix/releases/download/0.24/mairix-0.24.tar.gz"
  sha256 "a0702e079c768b6fbe25687ebcbabe7965eb493d269a105998c7c1c2caef4a57"
  license "GPL-2.0-only"
  head "https://github.com/vandry/mairix.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91307d1806d9def7532d3966be022cc28f5493f0989c03c44ba32a43f4cf52e4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3dabeb1e236f11f349787f65d4546483721fcc7fc5490f7b7af2c7886c767b6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7bb9a66e3039f4f5a4dbacfb99de292232fb4bf9d390f984ed7c39a6b6b54c39"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb9bffaff610f07604580441a5e32a24611a254af3be27e0052b28976737f32b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dfd83255b38f19058ac7f39ba79f17f64ab95bc326c1f25d8d86d232eb7c95a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6dfa5d6d778210169d8e753e060b857106bbd5a59d111e90342c0fe1cc330002"
  end

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV.deparallelize
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"mairix", "--version"
  end
end
