class Blint < Formula
  include Language::Python::Virtualenv

  desc "Security linter and SBOM generator for binaries"
  homepage "https://github.com/owasp-dep-scan/blint"
  url "https://files.pythonhosted.org/packages/69/b3/dd4898b70f09ed74a1ce2ca93af7b92dd7ecd379497397f7404c8c14811e/blint-4.0.1.tar.gz"
  sha256 "7e6aaf6df449af2f8abc897848a5a145d09e0b7ecc333888842e1a32d7760f68"
  license "MIT"
  head "https://github.com/owasp-dep-scan/blint.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4586811555d8ce189c012a33ec52784877c9f51ef3d163a722a0f7a4f9bc260f"
    sha256 cellar: :any, arm64_tahoe:       "17823b6b1c00653cceb087469fda4f7adbcc42ca0d70eaf6bf4e91095b33c179"
    sha256 cellar: :any, arm64_sequoia:     "ce0c1720df48c911e660f0ad78e9ec33edf533765fa5a5d71c2fbad222f1fae4"
    sha256 cellar: :any, arm64_linux:       "288f1bcb8f1da3b16659b0e01c1446385cb3d01490b3849007ce4d9832fb9a5d"
    sha256 cellar: :any, x86_64_linux:      "2392e0dd8ceda5692f90354c142be143a8c1e07df5e3524914255363fd476705"
  end

  depends_on "cmake" => :build # for lief
  depends_on "ninja" => :build # for lief
  depends_on "rust" => :build
  depends_on "tl-expected" => :build # for lief
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "lief"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.15"
  depends_on "rpds-py" => :no_linkage
  depends_on "sqlite" # APSW needs a newer version of SQLite than what macOS ships with

  pypi_packages exclude_packages: %w[certifi pydantic rpds-py]

  resource "apkinspector" do
    url "https://files.pythonhosted.org/packages/d4/8d/dd382dd4fd58799634d66d8f6eafe2c951a35971aacad6f6f3df6f111383/apkinspector-1.3.7.tar.gz"
    sha256 "ea5a62f9c6a3127a6191901fa0cc32e23b05caf2034d7062193bd4c0539c7888"
  end

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "apsw" do
    url "https://files.pythonhosted.org/packages/84/75/be84a7237ea1af8374c67ff7468053bff538e1591526805c6574b2efef4d/apsw-3.54.1.0.tar.gz"
    sha256 "d9fd64ed76dc0f3d2265d4aeedb74d678c2ac7dffbd4e8ba05bf9a87aa7c34d3"
  end

  resource "ar" do
    url "https://files.pythonhosted.org/packages/2b/0f/13f26fda15101f3415fab75456f5abc967a8c848287cf0b3dabc4b64d65a/ar-1.0.1.tar.gz"
    sha256 "8fc8e64ac2fd157b9f285b1c981083f2e906258322ff5e4413c0096f67fc2003"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "custom-json-diff" do
    url "https://files.pythonhosted.org/packages/b6/f9/670514efaceb028f739106231acfae1813638387742e130cd5561949c10e/custom_json_diff-2.1.6.tar.gz"
    sha256 "26d62a7f2fc61327c3bcda00b65d820f503682f242afcb1d2305186f8745e10e"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/ef/4a/50822184bd67cc6493f0fb6a880749158fcd31ab3fa07409acfd91f9fc85/dnspython-2.9.0.tar.gz"
    sha256 "b44dc6b18f07a8b1c56676a19fbfdb5209415b046a9cece286baafa87ff3f7f1"
  end

  resource "email-validator" do
    url "https://files.pythonhosted.org/packages/f5/22/900cb125c76b7aaa450ce02fd727f452243f2e91a61af068b40adba60ea9/email_validator-2.3.0.tar.gz"
    sha256 "9fc05c37f2f6cf439ff414f8fc46d917929974a82244c20eb10231ba60c54426"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "json-flatten" do
    url "https://files.pythonhosted.org/packages/a1/06/e6a7046e71488a899a990206dc2426e8b9192ab7a341bb95a75ac1c88922/json_flatten-0.3.1.tar.gz"
    sha256 "70e813acf431b1ab7e9eb7b98f5733d307d6b9d27b553a344904b9c8eafdad3a"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/b3/fc/e067678238fa451312d4c62bf6e6cf5ec56375422aee02f9cb5f909b3047/jsonschema-4.26.0.tar.gz"
    sha256 "0c26707e2efad8aa1bfc5b7ce170f3fccc2e4918ff85989ba9ffa9facb2be326"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/38/9b/e422a865e1d5d57d0e509b4e0bf1c1a70a7f6382c29a5aa428df994c8bc8/markupsafe-3.0.4.tar.gz"
    sha256 "2e9ad7dd851bf45fab9f75cbff4cb493fee9979e8d8c7c9c3ee119022518edd6"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "multi-demangle" do
    url "https://files.pythonhosted.org/packages/c6/7b/56d77b4171d89276ad93a3ab11fbb2a44d85b0904c0467841cb9d41c5997/multi_demangle-2.1.1.tar.gz"
    sha256 "e453c1c1286935e0653ffc570a327dc9b2509bba5c29170660d63a1640537366"
  end

  resource "oras" do
    url "https://files.pythonhosted.org/packages/c5/d2/dc4a3eb07ac779455dbfbc85cd396025ad72450ed7673a323c685cfb6774/oras-0.2.43.tar.gz"
    sha256 "761f2b518fce50e5e9482975363ff0230f63fc65f84c09510fbcc301782a047c"
  end

  resource "orjson" do
    url "https://files.pythonhosted.org/packages/f2/72/380b97dc45bd162d23afe5194721ef678d9eac7cfaa549fe2873f7f0a518/orjson-3.13.0.tar.gz"
    sha256 "d1de5eb04485110c5da4c657e49168995d55e076b1ce60f1a042e254f4186c4f"
  end

  resource "packageurl-python" do
    url "https://files.pythonhosted.org/packages/f5/d6/3b5a4e3cfaef7a53869a26ceb034d1ff5e5c27c814ce77260a96d50ab7bb/packageurl_python-0.17.6.tar.gz"
    sha256 "1252ce3a102372ca6f86eb968e16f9014c4ba511c5c37d95a7f023e2ca6e5c25"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/22/f5/df4e9027acead3ecc63e50fe1e36aca1523e1719559c499951bb4b53188f/referencing-0.37.0.tar.gz"
    sha256 "44aefc3142c5b842538163acb373e24cce6632bd54bdb01b21ad5863489f50d8"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "semver" do
    url "https://files.pythonhosted.org/packages/92/f5/e1dfe8e1d91c54ce212fd93916eb01fd1c590f413be0a0978c39a97aa1bb/semver-3.1.0.tar.gz"
    sha256 "14bc073439513d7773662a338f4db9829cf16c12b74b9568e2d2689975fbd7fc"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "wasm-tools" do
    url "https://files.pythonhosted.org/packages/da/f9/3a6260818f6b7b7aa23b204a06e8a8ea6cb1f7d64cd2ab47eb1afaefe332/wasm_tools-2.1.0.tar.gz"
    sha256 "fbfd4a962462e6128eb37446957d9ccac4e18b34d2cb894821697139d12f26d4"
  end

  # Python bindings for the `lief` formula, so keep both at the same version
  # The PyPI sdist has no sources to build from
  resource "lief" do
    url "https://github.com/lief-project/LIEF/archive/refs/tags/1.0.0.tar.gz"
    sha256 "2cf412695ff739d82e129db441e5c2025f3bb4873a3d3a1d3dd4cf300b682abd"

    livecheck do
      url :url
    end
  end

  resource "homebrew-test-library", :test do
    url "https://raw.githubusercontent.com/owasp-dep-scan/blint/fc39d1202f550d701a9f6564230488aa96e8cc26/tests/data/android/liba5_static_arm64-v8a_stripped.so"
    sha256 "fd8fd1b3e5b31ffbb583b952aa7864a87fdeb969b97bccf6fbf9b74ceb836a0b"
  end

  deny_network_access! :test

  def install
    # Remove the Python 3.15 cap, as upstream did after 4.0.1
    # https://github.com/owasp-dep-scan/blint/commit/d0a8b9e281a1
    inreplace "pyproject.toml", 'requires-python = ">=3.10,<3.15"', 'requires-python = ">=3.10"' if build.stable?

    venv = virtualenv_install_with_resources without: %w[apsw lief]

    resource("apsw").stage do
      # Use the brewed SQLite library instead of downloading and building one
      rm "setup.apsw"
      venv.pip_install Pathname.pwd
    end

    # Build only the Python bindings, linking the brewed LIEF library
    # https://lief.re/doc/latest/compilation.html#python-bindings
    resource("lief").stage do
      inreplace "api/python/config-default.toml", "[lief.build]\n", <<~TOML
        [lief.build]
        lief-install-dir = "#{formula_opt_prefix("lief")}"
        extra-cmake-opt = ["-DLIEF_PY_LIEF_EXT_SHARED=ON"]
      TOML
      # LIEF's CMake package only finds its dependencies for the static library,
      # but the shared one also links `tl::expected`
      inreplace "CMakeLists.txt", "find_package(LIEF REQUIRED)\n", <<~CMAKE
        find_package(tl-expected REQUIRED)
        find_package(LIEF REQUIRED)
      CMAKE
      venv.pip_install Pathname.pwd/"api/python"
    end
  end

  test do
    resource("homebrew-test-library").stage testpath
    library = "liba5_static_arm64-v8a_stripped.so"

    system bin/"blint", "-i", library, "-o", "reports"
    findings = JSON.parse((testpath/"reports/findings.json").read)["findings"]
    assert_includes findings.map { |finding| finding["id"] }, "CHECK_CANARY"

    system bin/"blint", "sbom", "-i", library, "-o", "bom.json"
    components = JSON.parse((testpath/"bom.json").read)["components"]
    assert_includes components.map { |component| component["name"] }, "libc.so"
  end
end
