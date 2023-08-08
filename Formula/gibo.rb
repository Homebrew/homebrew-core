class Gibo < Formula
  desc "Access GitHub's .gitignore boilerplates"
  homepage "https://github.com/simonwhitaker/gibo"
  url "https://github.com/simonwhitaker/gibo/archive/v3.0.3.tar.gz"
  sha256 "d3d76b30d8c61d203304af1805ca3abf77e96c6528f468c4d14830656f982f5c"
  license "Unlicense"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0cbd91c1329b75076e513e33b0203c873f679dac0786565a4dc419f1af8cb437"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0cbd91c1329b75076e513e33b0203c873f679dac0786565a4dc419f1af8cb437"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0cbd91c1329b75076e513e33b0203c873f679dac0786565a4dc419f1af8cb437"
    sha256 cellar: :any_skip_relocation, ventura:        "354a0167a96366353a252adfbeb4e42a4961223117ce339fb42747a4749b93ab"
    sha256 cellar: :any_skip_relocation, monterey:       "354a0167a96366353a252adfbeb4e42a4961223117ce339fb42747a4749b93ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "354a0167a96366353a252adfbeb4e42a4961223117ce339fb42747a4749b93ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aef06e61de7bb09531590e7ee1338500d547c8505bc7b3543b931e9a66371c7b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/simonwhitaker/gibo/cmd.version=#{version}
      -X github.com/simonwhitaker/gibo/cmd.commit=brew
      -X github.com/simonwhitaker/gibo/cmd.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
    generate_completions_from_executable(bin/"gibo", "completion")
  end

  test do
    system "#{bin}/gibo", "update"
    assert_includes shell_output("#{bin}/gibo dump Python"), "Python.gitignore"

    assert_match version.to_s, shell_output("#{bin}/gibo version")
  end
end
