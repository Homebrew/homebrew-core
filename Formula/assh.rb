class Assh < Formula
  desc "Advanced SSH config - Regex, aliases, gateways, includes and dynamic hosts"
  homepage "https://github.com/moul/advanced-ssh-config"
  url "https://github.com/moul/advanced-ssh-config/archive/v2.4.0.tar.gz"
  sha256 "4929e2c3947b383fb86550f23528590e45b9d5166b1d001c9ef043d9e5c5fbf3"
  head "https://github.com/moul/advanced-ssh-config.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9748773b78f5e26395ba7349ed4cf146bde0e1060fddc39da9db49f729ed61f2" => :el_capitan
    sha256 "35b4396e64c982dbbfb8c4f4069d980fc3dafd87920d594047986fe43a1df42e" => :yosemite
    sha256 "0bb33a27dabce1814aa0872aac845d1722c2bd1967dde5a29bfcdcc172be796f" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/moul/advanced-ssh-config").install Dir["*"]
    cd "src/github.com/moul/advanced-ssh-config/cmd/assh" do
      system "go", "build", "-o", bin/"assh"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/assh --version")
  end
end
