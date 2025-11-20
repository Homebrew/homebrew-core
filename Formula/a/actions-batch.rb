class ActionsBatch < Formula
  desc "Time-sharing supercomputer built on GitHub Actions"
  homepage "https://github.com/alexellis/actions-batch"
  url "https://github.com/alexellis/actions-batch/archive/refs/tags/v0.0.3.tar.gz"
  sha256 "9290b338e41ff71fb599de9996c64e33a58ec9aa4e8fdd7c4484ec2b085f2160"
  license "MIT"
  head "https://github.com/alexellis/actions-batch.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "59536a5a9f181ae349d14c6c2b55d6a8e022365f1ae425321e6ceccb43d9f4b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "275c7fbcf663d2acb91d05bde500b7138a1cb7f5df5f1247c887ca7bbe823019"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6c3348aebf7b7b6c6645d01cd1348a976f6225e30a1669d147af6629fc93f131"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30e6fab61cadce4dc40248d1a17884dbfc0595e1ef06108f9375988b1bc87e6c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f199258b2393f9ae2d333e13e38b75fb4913cc3e74eea6625e3b44638159d018"
    sha256 cellar: :any_skip_relocation, sonoma:         "9105a8d2904a59cb2be1808eb38576c2e9910fbb485b415cf89604f6bce65a43"
    sha256 cellar: :any_skip_relocation, ventura:        "20bb3b2e0c456933a1af59fc18ea0b528de5cae7e9206a1f65b8cac0ae49a7cb"
    sha256 cellar: :any_skip_relocation, monterey:       "70c67253a00f5e78afb71eb99933748d8d079466e8e880cee888c80bbcc529b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "4013124489ea2fb57e41de5bac37a514888b6d38adb121c6d6ebd3ec993520cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8dfaef2b9edcf0f025dafa223cecbdd96bfeebcc01feac706576d0fae729ef2"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    pkgshare.install "examples"
  end

  test do
    # fake token file
    (testpath/"notvavlid").write "fake"

    cmd = "#{bin}/actions-batch --private=false --owner alexellis " \
          "--token-file #{testpath}/notvavlid --runs-on ubuntu-latest " \
          "--org=false --file #{pkgshare}/examples/curl.sh"

    output = shell_output("#{cmd} 2>&1", 2)
    assert_match "failed to create repo", output
  end
end
