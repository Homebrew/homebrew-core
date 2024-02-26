class ActionsBatch < Formula
  desc "Time-sharing supercomputer built on GitHub Actions"
  homepage "https://github.com/alexellis/actions-batch"
  url "https://github.com/alexellis/actions-batch/archive/refs/tags/v0.0.3.tar.gz"
  sha256 "9290b338e41ff71fb599de9996c64e33a58ec9aa4e8fdd7c4484ec2b085f2160"
  license "MIT"
  head "https://github.com/alexellis/actions-batch.git", branch: "master"

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
    assert_match "POST https://api.github.com/user/repos: 401 Bad credentials", output
  end
end
