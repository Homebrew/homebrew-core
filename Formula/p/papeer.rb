class Papeer < Formula
  desc "Convert websites into eBooks and Markdown"
  homepage "https://papeer.tech"
  url "https://github.com/lapwat/papeer/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "102c77d982228794028d83b637a2491de10fb34314a2a9f07a363a45fd73eaea"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "368b648e41961c76013cdd6d37d7ef1828fdc883255db228ed45ae11a93f5dff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "368b648e41961c76013cdd6d37d7ef1828fdc883255db228ed45ae11a93f5dff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "368b648e41961c76013cdd6d37d7ef1828fdc883255db228ed45ae11a93f5dff"
    sha256 cellar: :any_skip_relocation, sonoma:        "dcc81fd87cccb77418e2cbbc70645b1e20f52c88ce72b9a9ef19e4f1bb5afbc8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7ecace08c32bc5549e4497324406a26771783fbe0111aefb8fca6f75f2d04fff"
    sha256 cellar: :any,                 x86_64_linux:  "3475bfe96ec8bbda2ecee4396762c4a30f75701368010f41d0f1ffabb62f32d6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"papeer", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/papeer version")

    output = shell_output("#{bin}/papeer list https://12factor.net/ --selector='section.concrete>article>h2>a'")
    assert_match "8  VIII. Concurrency", output
  end
end
