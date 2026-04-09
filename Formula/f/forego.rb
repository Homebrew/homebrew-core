class Forego < Formula
  desc "Foreman in Go for Procfile-based application management"
  homepage "https://github.com/ddollar/forego"
  license "Apache-2.0"
  head "https://github.com/ddollar/forego.git", branch: "master"

  stable do
    url "https://github.com/ddollar/forego/archive/refs/tags/20180216151118.tar.gz"
    sha256 "23119550cc0e45191495823aebe28b42291db6de89932442326340042359b43d"

    # Add go.mod
    patch do
      url "https://github.com/ddollar/forego/commit/89fb456a167f59ace41e0e9294f4b7c01f76943e.patch?full_index=1"
      sha256 "98274160eb0251af323df030f8f05369ab19b0116a2b87e58372974bae5c0524"
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0c76f88ef642e7133f7ac7db298cdda3ae5fd17a5c6c49bf5481d8dab5ebedb1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0c76f88ef642e7133f7ac7db298cdda3ae5fd17a5c6c49bf5481d8dab5ebedb1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0c76f88ef642e7133f7ac7db298cdda3ae5fd17a5c6c49bf5481d8dab5ebedb1"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d68b3831d4f0a74ec867a1a094b4358bf7e377a140b378ed326e753579413ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5931db5b7571c1ddccd603345fd8780cb7f9d37f1eefd28dc5853f6fbfea1ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9dca3d980006ef9588d0511bfcc5e1c471c786b0705e6b35f51e2f482a942675"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.allowUpdate=false"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    (testpath/"Procfile").write "web: echo 'it works!'"
    assert_match "it works", shell_output("#{bin}/forego start")
  end
end
