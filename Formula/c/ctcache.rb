class Ctcache < Formula
  include Language::Python::Virtualenv

  desc "Cache for clang-tidy static analysis results"
  homepage "https://github.com/matus-chochlik/ctcache"
  url "https://github.com/matus-chochlik/ctcache/archive/refs/tags/1.2.0.tar.gz"
  sha256 "8a5423bf81599f4613c771b144dbbad1125af86eac622fc0d500f8dc1105a16b"
  license "BSL-1.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "f4d1bb12ce49b05ad4c90d6684c8915f9d38601d24f446e9010cd01377e0fbc3"
  end

  depends_on "certifi" => :no_linkage
  depends_on "python@3.15"

  pypi_packages package_name:     "",
                extra_packages:   %w[requests],
                exclude_packages: "certifi"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  # pip still needs to fetch the project's chosen build system via the network.
  allow_network_access! :build

  def install
    ENV["SETUPTOOLS_SCM_PRETEND_VERSION_FOR_CTCACHE"] = version
    virtualenv_install_with_resources
  end

  test do
    ENV["CTCACHE_DIR"] = testpath/"cache"
    assert_equal (testpath/"cache").to_s, shell_output("#{bin}/clang-tidy-cache --cache-dir").strip

    # Fake clang-tidy that records its runs.
    (testpath/"clang-tidy").write <<~SHELL
      #!/bin/sh
      case " $* " in
        *" --dump-config "*) echo "Checks: '-*'" ;;
        *) echo run >> "#{testpath}/calls.txt" ;;
      esac
    SHELL
    chmod 0755, testpath/"clang-tidy"

    (testpath/"test.cpp").write "int main() { return 0; }"

    # The first call should go through, the second one should use the cached result.
    2.times do
      system bin/"clang-tidy-cache", testpath/"clang-tidy", "test.cpp", "--", ENV.cc, "-c", "test.cpp"
    end
    assert_equal 1, (testpath/"calls.txt").read.lines.count
  end
end
