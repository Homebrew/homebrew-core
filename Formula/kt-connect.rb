class KtConnect < Formula
  desc "Toolkit for integrating with kubernetes dev environment more efficiently"
  homepage "https://alibaba.github.io/kt-connect/#/"
  url "https://github.com/alibaba/kt-connect/archive/refs/tags/v0.3.5.tar.gz"
  sha256 "b1a2f0f71feb7d8c4418f73048c24687d513dc1cabb1f68ffac3be5baa0e3f5a"
  license "GPL-3.0-or-later"

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "-o", bin/"ktctl", "./cmd/ktctl"

    # Install bash completion
    output = Utils.safe_popen_read(bin/"ktctl", "completion", "bash")
    (bash_completion/"ktctl").write output

    # Install zsh completion
    output = Utils.safe_popen_read(bin/"ktctl", "completion", "zsh")
    (zsh_completion/"_ktctl").write output

    # Install fish completion
    output = Utils.safe_popen_read(bin/"ktctl", "completion", "fish")
    (fish_completion/"ktctl.fish").write output
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ktctl --version")
  end
end
