class Litecli < Formula
  include Language::Python::Virtualenv

  desc "CLI for SQLite Databases with auto-completion and syntax highlighting"
  homepage "https://litecli.com"
  url "https://files.pythonhosted.org/packages/e3/d5/afec99cc3eaba96214d77e76438d7fe5e6ea54704b0e47dd97d9696ccd6c/litecli-1.17.1.tar.gz"
  sha256 "e2f7191eaba830b24dbbfc9171a495c62562df923ba1cc3b2db2652547c1bac8"
  license "BSD-3-Clause"
  revision 3

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "17258ed044d8936e3544fb740060cb0ec9168aaab59f6a083fe8898922bbd296"
    sha256 cellar: :any, arm64_sequoia: "be446aff92430a81d3df6f4b74a906000eb2d078ac76cb92226a001870b92f89"
    sha256 cellar: :any, arm64_sonoma:  "8fa4ba38b371e8fa35ba96331ca977294d5eea8001f3888e135507046e70c317"
    sha256 cellar: :any, sonoma:        "634cd4844b8ae6e769b3cf534b9f5aa4cdabcec2cc8c1c94f3856b33d9f7897c"
    sha256 cellar: :any, arm64_linux:   "04b8915295e8e5ce5a9f45ac9d13735e612dd559813fe0d77827ebc3c79116a8"
    sha256 cellar: :any, x86_64_linux:  "acfe93b6757876dae58baf591f425c793693485353d771af7ca42bfe016c36a0"
  end

  depends_on "rust" => :build # for jiter
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"

  uses_from_macos "sqlite"

  pypi_packages package_name:     "litecli[ai]",
                exclude_packages: %w[certifi pydantic setuptools]

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/61/cc/a381afa6efea9f496eff839d4a6a1aed3bfafc7b3ab4b0d1b243a12573dd/anyio-4.14.2.tar.gz"
    sha256 "cfa139f3ed1a23ee8f88a145ddb5ac7605b8bbfd8592baacd7ce3d8bb4313c7f"
  end

  resource "cli-helpers" do
    url "https://files.pythonhosted.org/packages/3f/de/278f4885fcd03661ab9b69dba9fc745c27d820858dbc06e427057899dcf5/cli_helpers-2.15.1.tar.gz"
    sha256 "e9c0826dda2855745eb63b3fd8e33b6ac8881188f2ba91e51a516ed833fc0cb8"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/76/d4/81420972a676e8ffea40450d8c8c92943e7218a78fe9b64359836cc9876b/click-8.4.2.tar.gz"
    sha256 "9a6cea6e60b17ebe0a44c5cc636d94f09bd66142c1cd7d8b4cd731c4917a15f6"
  end

  resource "click-default-group" do
    url "https://files.pythonhosted.org/packages/1d/ce/edb087fb53de63dad3b36408ca30368f438738098e668b78c87f93cd41df/click_default_group-1.2.4.tar.gz"
    sha256 "eb3f3c99ec0d456ca6cd2a7f08f7d4e91771bef51b01bdd9580cc6450fe1251e"
  end

  resource "condense-json" do
    url "https://files.pythonhosted.org/packages/d1/a5/7158b674fa5b890d80faaf42dd438d1a765661cd22430ddf499759cf44e1/condense_json-1.1.tar.gz"
    sha256 "c455b54bbbab89a69f598b09f2003a89b738df20d30e6aa341c495401ec5b349"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/f5/c4/c7f9e41bc2e5f8eeae4a08a01c91b2aea3dfab40a3e14b25e87e7db8d501/configobj-5.0.9.tar.gz"
    sha256 "03c881bbf23aa07bccf1b837005975993c4ab4427ba57f959afdd9d1a2386848"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore2" do
    url "https://files.pythonhosted.org/packages/a9/83/a896fc59940fc5a6e2aff3a4be1d92fa890112936803b331cae75a993c34/httpcore2-2.10.0.tar.gz"
    sha256 "13c0cc3d1919d4f28457f60cd2c2abe04113a8af184ccf1142811beba936f9dc"
  end

  resource "httpx2" do
    url "https://files.pythonhosted.org/packages/bd/3d/f9a8c07a3884f3e5b26205e8436a18b3af61c5d53192c3bea235574dbbec/httpx2-2.10.0.tar.gz"
    sha256 "8741d7329fe2c7885fc9ceb61c8217acfb87a85f75723714b89ebf7ad7196338"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/cd/63/9496c57188a2ee585e0f1db071d75089a11e98aa86eb99d9d7618fc1edce/idna-3.18.tar.gz"
    sha256 "ffb385a7e039654cef1ab9ef32c6fafe283c0c0467bba1d9029738ce4a14a848"
  end

  resource "jiter" do
    url "https://files.pythonhosted.org/packages/1d/1f/10936e16d8860c70698a1aa939a46aa0224813b782bce4e000e637da0b2d/jiter-0.16.0.tar.gz"
    sha256 "7b24c3492c5f4f84a37946ad9cf504910cf6a782d6a4e0689b6673c5894b4a1c"
  end

  resource "llm" do
    url "https://files.pythonhosted.org/packages/b7/bd/af98f3401bab026f3153de0edba65ff56e56ac7abaf34ab568cf461cd7f9/llm-0.32.tar.gz"
    sha256 "76adad7cceddbe65e970a96ee879fc75709ce05fdfb7ca9503b66bede5933679"
  end

  resource "openai" do
    url "https://files.pythonhosted.org/packages/58/9b/d45911bf9abfc5a754d800d79fe56e4dcf6e7b679d6ff4b7e9689b56bc02/openai-3.1.0.tar.gz"
    sha256 "3ae7190da63f718727f9c525740d3f713e85553d2bf1d0cc9247346bd9063a4d"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/7d/ea/39b988c938f75cb75d7045b5c69f8bfed47ee2152c8837fb403de29d6fb8/prompt_toolkit-3.0.53.tar.gz"
    sha256 "9ec8a0ad96d5c56148b3f914aa79c1564c3fde5d2e6b876e7bc327e353cf8fa6"
  end

  resource "puremagic" do
    url "https://files.pythonhosted.org/packages/24/74/ce5987ab9b8aec4ced06e2723ebb604205c9eb58abdad91453da93166380/puremagic-2.2.0.tar.gz"
    sha256 "eb4bddf07c177c4b434554b92165b67449f5a51e152b976202d6254498810eef"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-ulid" do
    url "https://files.pythonhosted.org/packages/d6/41/65079023c81491a21799c0120bce5925366b6913596bf797806f19973290/python_ulid-4.0.1.tar.gz"
    sha256 "bbeec02556190bb9dc3401faa7268696acbfbe7b6db9908c155dc3548629f20c"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "sqlite-fts4" do
    url "https://files.pythonhosted.org/packages/c2/6d/9dad6c3b433ab8912ace969c66abd595f8e0a2ccccdb73602b1291dbda29/sqlite-fts4-1.0.3.tar.gz"
    sha256 "78b05eeaf6680e9dbed8986bde011e9c086a06cb0c931b3cf7da94c214e8930c"
  end

  resource "sqlite-utils" do
    url "https://files.pythonhosted.org/packages/7e/6b/4a7b3d20c92e6c7acedc96ef620df8e1ea8f94a26a41ab788c1c08055815/sqlite_utils-4.2.1.tar.gz"
    sha256 "76114b6a5414714e6c70e5fa5c4781b301b590f6951b5da39c8cc60c21382ba1"
  end

  resource "sqlparse" do
    url "https://files.pythonhosted.org/packages/5f/d3/3f06a1006f2261d1342aefb3c71eed02f5d4ca5bdbecd86ebc12ad38306e/sqlparse-0.6.0.tar.gz"
    sha256 "113c35c75365ab9cc9c7231d68c6428fb11c085fc8e9eb1ad659b7ddbf6cd2b9"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/46/58/8c37dea7bbf769b20d58e7ace7e5edfe65b849442b00ffcdd56be88697c6/tabulate-0.10.0.tar.gz"
    sha256 "e2cfde8f79420f6deeffdeda9aaec3b6bc5abce947655d17ac662b126e48a60d"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/21/3b/6c24bec5be5e743ffd99576daa5cc077722fc7d5bbc00bd133fa0c698dc6/tqdm-4.70.0.tar.gz"
    sha256 "55b0b0dbd97462d06ebee91e4dac24ed4d4702be82b24f07e6c1d27e08cea220"
  end

  resource "truststore" do
    url "https://files.pythonhosted.org/packages/53/a3/1585216310e344e8102c22482f6060c7a6ea0322b63e026372e6dcefcfd6/truststore-0.10.4.tar.gz"
    sha256 "9d91bd436463ad5e4ee4aba766628dd6cd7010cf3e2461756b3303710eebc301"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/34/74/c6428f875774288bec1396f5bfcbc2d925700a4dad61727fd5f2b12f249d/wcwidth-0.8.2.tar.gz"
    sha256 "91fbef97204b96a3d4d421609b80340b760cf33e26da123ff243d76b1fda8dda"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"litecli", shell_parameter_format: :click)
  end

  test do
    (testpath/".config/litecli/config").write <<~INI
      [main]
      table_format = tsv
      less_chatty = True
    INI

    (testpath/"test.sql").write <<~SQL
      CREATE TABLE IF NOT EXISTS package_manager (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name VARCHAR(256)
      );
      INSERT INTO
        package_manager (name)
      VALUES
        ('Homebrew');
    SQL
    system "sqlite3 test.db < test.sql"

    require "pty"
    output = ""
    PTY.spawn("#{bin}/litecli test.db") do |r, w, _pid|
      sleep 2
      w.puts "SELECT name FROM package_manager"
      w.puts "quit"

      begin
        r.each_line { |line| output += line }
      rescue Errno::EIO
        # GNU/Linux raises EIO when read is done on closed pty
      end
    end

    # remove ANSI colors
    output.gsub!(/\e\[([;\d]+)?m/, "")
    # normalize line endings
    output.gsub!("\r\n", "\n")

    expected = <<~EOS
      name
      Homebrew
      1 row in set
    EOS

    assert_match expected, output
  end
end
