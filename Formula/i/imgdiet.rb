class Imgdiet < Formula
  desc "Optimize and resize images"
  homepage "https://git.sr.ht/~jamesponddotco/imgdiet-go"
  url "https://git.sr.ht/~jamesponddotco/imgdiet-go/archive/v0.2.0.tar.gz"
  sha256 "25fcdc40ad63ce2739fad6543c592d757dc59d5c7a409af87cb20884600984ce"
  license "MIT"
  head "https://git.sr.ht/~jamesponddotco/imgdiet-go", branch: "trunk"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0e3c098f6f4fb839c6e45c17c3b2c28e1d263ce52a6a5bff3139c27522c171f9"
    sha256 cellar: :any,                 arm64_sequoia: "3f2124dea87682bc905fb403d3cfb36b16193959e56e267de9c31c73c8a5c708"
    sha256 cellar: :any,                 arm64_sonoma:  "f105f52dbd1a99c8a8326845841da7f2236060e11ca3cec2c4b96f9f8375f876"
    sha256 cellar: :any,                 arm64_ventura: "fc829c032e756ecb5b56c0998c24147db43f76ef1498961a2b59ebb04bb1b6d5"
    sha256 cellar: :any,                 sonoma:        "ae731c0d8dca0947f6015f1024ce4b41206c00c9e497a62f0f834965a4c67852"
    sha256 cellar: :any,                 ventura:       "947efce27e3c0ef5a9be6fba6fa4fe3c7f6d926ed27bb1e3f62d04cf4c2eb65d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "88213cd44379f758de4930796e8006a2354fa4f6347205526bd139e0399f3f85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7c06e10203f59029e144945345f81e9efbbe4b758442441f35a9e6d85b603e7"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  depends_on "glib"
  depends_on "vips"

  on_macos do
    depends_on "gettext"
  end

  def install
    # Workaround to avoid patchelf corruption when cgo is required
    if OS.linux? && Hardware::CPU.arch == :arm64
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/imgdiet"
  end

  test do
    system bin/"imgdiet", "--compression", "9", test_fixtures("test.png"), testpath/"out.jpg"
    assert_path_exists testpath/"out.jpg"
  end
end
