class Getparty < Formula
  desc "Multi-part HTTP download manager"
  homepage "https://github.com/vbauerster/getparty"
  url "https://github.com/vbauerster/getparty/archive/refs/tags/v1.28.3.tar.gz"
  sha256 "ab12d1eaad86477370a93b1cdca8ab5e4ff8465b364374d2786a8cc700d710c0"
  license "BSD-3-Clause"
  head "https://github.com/vbauerster/getparty.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b519d911f8c2f848898fc230be948d84f9fb1a0c058b3bb000563b11ee095d78"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b519d911f8c2f848898fc230be948d84f9fb1a0c058b3bb000563b11ee095d78"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b519d911f8c2f848898fc230be948d84f9fb1a0c058b3bb000563b11ee095d78"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d40e38dc0f94f7c13ebfd2ee1bbb3dd2cd9b6d5cda2aca8f90a844784e069ac9"
    sha256 cellar: :any,                 x86_64_linux:      "68db38b7a9003e566ead3aef404a4cd911f67c411250dbe610de9bb83afb18b4"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    # The commit variable only displays 7 characters, so we can't use #{tap.user} or "Homebrew".
    ldflags = %W[
      -X main.version=#{version}
      -X main.commit=brew
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/getparty"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/getparty --version")

    output = shell_output("#{bin}/getparty http://media.vimcasts.org/videos/10/ascii_art.ogv")
    assert_match "\"ascii_art.ogv\" saved", output
  end
end
