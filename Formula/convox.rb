class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.0.43.tar.gz"
  sha256 "65dd83b2ac9384b95893941f2392de8c87a462438d463834805a82ee48f62df6"
  license "Apache-2.0"
  version_scheme 1

  bottle do
    cellar :any_skip_relocation
    sha256 "aa99b99d4f3240df0d16fcb87a6d82ade028cfa2fde233845eeedd045c1010b7" => :catalina
    sha256 "956f26de67528c09d5799594db799fed23c7d4f6a613d7039590ba8f1c3b89b9" => :mojave
    sha256 "028c33f6740c14e2f0b0cbb3aa5e1f619f7e84eb438a30487acaac7e6b2a3abb" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.version=#{version}
    ].join(" ")

    system "go", "build", *std_go_args, "-mod=vendor", "-ldflags", ldflags, "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
