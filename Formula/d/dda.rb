class Dda < Formula
  desc "Tool for developing on the Datadog Agent platform"
  homepage "https://github.com/DataDog/datadog-agent"
  url "https://github.com/ofek/pyapp/releases/download/v0.28.0/source.tar.gz"
  version "0.23.1"
  sha256 "6baedee5288f2ae7de6537f1c4e92e04caaa642b01ada27edb0b1192c4688073"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url "https://pypi.org/pypi/dda/json"
    strategy :json do |json|
      json["info"]["version"]
    end
  end

  depends_on "rust" => :build

  def install
    ENV["PYAPP_PROJECT_NAME"] = "dda"
    ENV["PYAPP_PROJECT_VERSION"] = version
    ENV["PYAPP_PYTHON_VERSION"] = "3.12"
    ENV["PYAPP_EXEC_SPEC"] = "dda.cli:main"
    ENV["PYAPP_UV_ENABLED"] = "true"
    ENV["PYAPP_PASS_LOCATION"] = "true"

    system "cargo", "install", *std_cargo_args
    mv bin/"pyapp", bin/"dda"
  end

  test do
    assert_match "dda, version #{version}", shell_output("#{bin}/dda --version")
    system bin/"dda", "config", "set", "orgs.foo.api_key", "secret"
    system bin/"dda", "config", "set", "orgs.foo.brew-key", "brew-value"

    pattern = /
      \[orgs\.foo\]\s*
      \n
      api_key[ ]=[ ]"\*{5}"\s*
      \n
      brew-key[ ]=[ ]"brew-value"
    /x
    assert_match pattern, shell_output("#{bin}/dda config show 2>&1")
  end
end
