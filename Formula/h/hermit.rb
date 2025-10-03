class Hermit < Formula
  desc "Manages isolated, self-bootstrapping sets of tools in software projects"
  homepage "https://cashapp.github.io/hermit"
  url "https://github.com/cashapp/hermit/archive/refs/tags/v0.46.1.tar.gz"
  sha256 "dbb48d20a2a8737098fffc0a2397d91e4530e0cb1c2358f024322ecb22cc2af7"
  license "Apache-2.0"
  head "https://github.com/cashapp/hermit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "18d80f4e2e1c0f42953b5e053bd39ab972aa53fda4c034c3732f590705b303e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7e671cdf8325cef9a366851527910a609b47431ded147602c2f88b9a218bc138"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c34fd7f70223227fb61548ed5699c9ed3c11e946939238feee3f23e5969dd2ba"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e7ee02766f1529610a69be2bfcc4f0005a317ef39ae204ebe92258c1ecbfb5f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a58bd5e5d4828b695e06d07460c3cb1591c2a18b458f2e98e744609cd268967"
    sha256 cellar: :any_skip_relocation, ventura:       "431810ec6536b10e4124242fc71d51a012dcf4643d58cceeb5f628ecc300897c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2dd44e1c0da193c57de1738f63830a0e0afcf4febf994d531473636d0888e331"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48a03a98e1d985efc95394dac11cef2e5f1541330daeb85abfb2acc0a3a1a4bf"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.channel=stable
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/hermit"
  end

  def caveats
    <<~EOS
      For shell integration hooks, add the following to your shell configuration:

      For bash, add the following command to your .bashrc:
        eval "$(test -x $(brew --prefix)/bin/hermit && $(brew --prefix)/bin/hermit shell-hooks --print --bash)"

      For zsh, add the following command to your .zshrc:
        eval "$(test -x $(brew --prefix)/bin/hermit && $(brew --prefix)/bin/hermit shell-hooks --print --zsh)"
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hermit version")
    system bin/"hermit", "init", "."
    assert_path_exists testpath/"bin/hermit.hcl"
  end
end
