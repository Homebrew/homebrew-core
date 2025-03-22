class Aider < Formula
  include Language::Python::Virtualenv

  desc "AI pair programming in your terminal"
  homepage "https://aider.chat/"
  url "https://files.pythonhosted.org/packages/a6/1d/bc433cbd3df48abccf6f90a9cd27dff3d44e7dc3abe089566898f6ccad1a/aider_chat-0.77.0.tar.gz"
  sha256 "5797ee354f084aa072719986b9aaaad60aff651189fde47326c66d6e3c7f3e98"
  license "Apache-2.0"
  head "https://github.com/paul-gauthier/aider.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "652409d58aa7c2e9d07e6cb9d9268c805e8326f1d815255a1755915b3b50e9f3"
    sha256 cellar: :any,                 arm64_sonoma:  "2ecfc29b262c359cfa657f7a214c8efedb44efadb5872495d1d8c1fadbc25324"
    sha256 cellar: :any,                 arm64_ventura: "92846ac66a6b8321b01d60c2e782435f5a5746f9a635d8d09d0ad365f2803095"
    sha256 cellar: :any,                 sonoma:        "29647392581a86f690128878f55a7450d9b38c01ee75daf1651e2adeaba93d57"
    sha256 cellar: :any,                 ventura:       "8bc3f56674ba393f92a4b2603dd98d143da2841b4fdb4971408b038758e0fe6e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "847c3f9b07dd4da645d7c9e8e71916050551f739808ea1bfcfd85e7c9ed405c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "14541a87c748ad1fb5a5539acf25648ced364dddb4cc102841a90218b2eef124"
  end

  depends_on "rust" => :build # for pydantic_core
  depends_on "certifi"
  depends_on "cffi"
  depends_on "libyaml"
  depends_on "numpy"
  depends_on "pillow"
  depends_on "python@3.12" # py3.13 support issue, https://github.com/Aider-AI/aider/issues/3037
  depends_on "scipy"

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/26/30/f84a107a9c4331c14b2b586036f40965c128aa4fee4dda5d3d51cb14ad54/aiohappyeyeballs-2.6.1.tar.gz"
    sha256 "c3f9d0113123803ccadfdf3f0faa505bc78e6a72d1cc4806cbd719826e943558"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/b3/3f/c4a667d184c69667b8f16e0704127efc5f1e60577df429382b4d95fd381e/aiohttp-3.11.13.tar.gz"
    sha256 "8ce789231404ca8fff7f693cdce398abf6d90fd5dae2b1847477196c243b1fbb"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/ba/b5/6d55e80f6d8a08ce22b982eafa278d823b541c925f11ee774b0b9c43473d/aiosignal-1.3.2.tar.gz"
    sha256 "a8c255c66fafb1e499c9351d0bf32ff2d8a0321595ebac3b93713656d2436f54"
  end

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a3/73/199a98fc2dae33535d6b8e8e6ec01f8c1d76c9adb096c6b7d64823038cde/anyio-4.8.0.tar.gz"
    sha256 "1d9fe889df5212298c0c0723fa20479d1b94883a2df44bd3897aa91083316f7a"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/69/82/3c4e1d44f3cbaa2a578127d641fe385ba3bff6c38b789447ae11a21fa413/attrs-25.2.0.tar.gz"
    sha256 "18a06db706db43ac232cce80443fcd9f2500702059ecf53489e3c5a3f417acaf"
  end

  resource "backoff" do
    url "https://files.pythonhosted.org/packages/47/d7/5bbeb12c44d7c4f2fb5b56abce497eb5ed9f34d85701de869acedd602619/backoff-2.2.1.tar.gz"
    sha256 "03f829f5bb1923180821643f8753b0502c3b682293992485b0eef2807afa5cba"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/f0/3c/adaf39ce1fb4afdd21b611e3d530b183bb7759c9b673d60db0e347fd4439/beautifulsoup4-4.13.3.tar.gz"
    sha256 "1bd32405dacc920b42b83ba01644747ed77456a65760e285fbc47633ceddaf8b"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/16/b0/572805e227f01586461c80e0fd25d65a2115599cc9dad142fee4b747c357/charset_normalizer-3.4.1.tar.gz"
    sha256 "44251f18cd68a75b56585dd00dae26183e102cd5e0f9f1466e6df5da2ed64ea3"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/b9/2e/0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8b/click-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "configargparse" do
    url "https://files.pythonhosted.org/packages/70/8a/73f1008adfad01cb923255b924b1528727b8270e67cb4ef41eabdc7d783e/ConfigArgParse-1.7.tar.gz"
    sha256 "e7067471884de5478c58a511e529f0f9bd1c66bfef1dea90935438d6c23306d1"
  end

  resource "cython" do
    url "https://files.pythonhosted.org/packages/5a/25/886e197c97a4b8e254173002cdc141441e878ff29aaa7d9ba560cd6e4866/cython-3.0.12.tar.gz"
    sha256 "b988bb297ce76c671e28c97d017b95411010f7c77fa6623dd0bb47eed1aee1bc"
  end

  resource "diff-match-patch" do
    url "https://files.pythonhosted.org/packages/0e/ad/32e1777dd57d8e85fa31e3a243af66c538245b8d64b7265bec9a61f2ca33/diff_match_patch-20241021.tar.gz"
    sha256 "beae57a99fa48084532935ee2968b8661db861862ec82c6f21f4acdd6d835073"
  end

  resource "diskcache" do
    url "https://files.pythonhosted.org/packages/3f/21/1c1ffc1a039ddcc459db43cc108658f32c57d271d7289a2794e401d0fdb6/diskcache-5.6.3.tar.gz"
    sha256 "2c3a3fa2743d8535d832ec61c2054a1641f41775aa7c556758a109941e33e4fc"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/dc/9c/0b15fb47b464e1b663b1acd1253a062aa5feecb07d4e597daea542ebd2b5/filelock-3.17.0.tar.gz"
    sha256 "ee4e77401ef576ebb38cd7f13b9b28893194acc20a8e68e18730ba9c0e54660e"
  end

  resource "flake8" do
    url "https://files.pythonhosted.org/packages/58/16/3f2a0bb700ad65ac9663262905a025917c020a3f92f014d2ba8964b4602c/flake8-7.1.2.tar.gz"
    sha256 "c586ffd0b41540951ae41af572e6790dbd49fc12b3aa2541685d253d9bd504bd"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/8f/ed/0f4cec13a93c02c47ec32d81d11c0c1efbadf4a471e3f3ce7cad366cbbd3/frozenlist-1.5.0.tar.gz"
    sha256 "81d5af29e61b9c8348e876d442253723928dce6433e0e76cd925cd83f1b4b817"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/34/f4/5721faf47b8c499e776bc34c6a8fc17efdf7fdef0b00f398128bc5dcb4ac/fsspec-2025.3.0.tar.gz"
    sha256 "a935fd1ea872591f2b5148907d103488fc523295e6c64b835cfad8c3eca44972"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/72/94/63b0fc47eb32792c7ba1fe1b694daec9a63620db1e313033d18140c2320a/gitdb-4.0.12.tar.gz"
    sha256 "5ef71f855d191a3326fcfbc0d5da835f26b13fbcba60c32c21091c349ffdb571"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/c0/89/37df0b71473153574a5cdef8f242de422a0f5d26d7a9e231e6f169b4ad14/gitpython-3.1.44.tar.gz"
    sha256 "c87e30b26253bf5418b01b0660f818967f3c503193838337fe5e573331249269"
  end

  resource "grep-ast" do
    url "https://files.pythonhosted.org/packages/33/c8/2b6e6f6967a4310989b743f635f297cb1e7e5f9d6750ec213412a65c4fc2/grep_ast-0.8.1.tar.gz"
    sha256 "8faf285f44042af47dc6a45f1e1f8029866048563d758a719b0539cad264187f"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/f5/38/3af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03/h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/6a/41/d7d0a89eb493922c37d343b607bc1b5da7f5be7e383740b4753ad8943e90/httpcore-1.0.7.tar.gz"
    sha256 "8551cb62a169ec7162ac7be8d4817d561f60e08eaa485234898414bb5a8a0b4c"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "huggingface-hub" do
    url "https://files.pythonhosted.org/packages/e5/f9/851f34b02970e8143d41d4001b2d49e54ef113f273902103823b8bc95ada/huggingface_hub-0.29.3.tar.gz"
    sha256 "64519a25716e0ba382ba2d3fb3ca082e7c7eb4a2fc634d200e8380006e0760e5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/76/72/33d1bb4be61f1327d3cd76fc41e2d001a6b748a0648d944c646643f123fe/importlib_metadata-7.2.1.tar.gz"
    sha256 "509ecb2ab77071db5137c655e24ceb3eee66e7bbc6574165d0d114d9fc4bbe68"
  end

  resource "importlib-resources" do
    url "https://files.pythonhosted.org/packages/cf/8c/f834fbf984f691b4f7ff60f50b514cc3de5cc08abfc3295564dd89c5e2e7/importlib_resources-6.5.2.tar.gz"
    sha256 "185f87adef5bcc288449d98fb4fba07cea78bc036455dd44c5fc4a2fe78fed2c"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "jiter" do
    url "https://files.pythonhosted.org/packages/1e/c2/e4562507f52f0af7036da125bb699602ead37a2332af0788f8e0a3417f36/jiter-0.9.0.tar.gz"
    sha256 "aadba0964deb424daa24492abc3d229c60c4a31bfee205aedbf1acc7639d7893"
  end

  resource "json5" do
    url "https://files.pythonhosted.org/packages/85/3d/bbe62f3d0c05a689c711cff57b2e3ac3d3e526380adb7c781989f075115c/json5-0.10.0.tar.gz"
    sha256 "e66941c8f0a02026943c52c2eb34ebeb2a6f819a0be05920a6f5243cd30fd559"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/38/2e/03362ee4034a4c917f697890ccd4aec0800ccf9ded7f511971c75451deec/jsonschema-4.23.0.tar.gz"
    sha256 "d71497fef26351a33265337fa77ffeb82423f3ea21283cd9467bb03999266bc4"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/10/db/58f950c996c793472e336ff3655b13fbcf1e3b359dcf52dcf3ed3b52c352/jsonschema_specifications-2024.10.1.tar.gz"
    sha256 "0f38b83639958ce1152d02a7f062902c41c8fd20d558b0c34344292d417ae272"
  end

  resource "litellm" do
    url "https://files.pythonhosted.org/packages/5c/7a/6c1994a239abd1b335001a46ae47fa055a24c493b6de19a9fa1872187fe9/litellm-1.63.7.tar.gz"
    sha256 "2fbd7236d5e5379eee18556857ed62a5ed49f4f09e03ff33cf15932306b984f1"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/b2/97/5d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62/markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/e7/ff/0ffefdcac38932a54d2b5eed4e0ba8a408f215002cd178ad1df0f2806ff8/mccabe-0.7.0.tar.gz"
    sha256 "348e0240c33b60bbdf4e523192ef919f28cb2c3d7d5c7794f74009290f236325"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "mixpanel" do
    url "https://files.pythonhosted.org/packages/bd/a3/9d71562db2107da31be6a988cac88cd1be11364d103b618a98ba92d2487b/mixpanel-4.10.1.tar.gz"
    sha256 "29a6b5773dd34f05cf8e249f4e1d16e7b6280d6b58894551ce9a5aad7700a115"
  end

  resource "monotonic" do
    url "https://files.pythonhosted.org/packages/ea/ca/8e91948b782ddfbd194f323e7e7d9ba12e5877addf04fb2bf8fca38e86ac/monotonic-1.6.tar.gz"
    sha256 "3a55207bcfed53ddd5c5bae174524062935efed17792e9de2ad0205ce9ad63f7"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/d6/be/504b89a5e9ca731cd47487e91c469064f8ae5af93b7259758dcfc2b9c848/multidict-6.1.0.tar.gz"
    sha256 "22ae2ebf9b0c69d206c003e2f6a914ea33f0a932d4aa16f236afc049d9958f4a"
  end

  resource "networkx" do
    url "https://files.pythonhosted.org/packages/c4/80/a84676339aaae2f1cfdf9f418701dd634aef9cc76f708ef55c36ff39c3ca/networkx-3.2.1.tar.gz"
    sha256 "9f1bb5cf3409bf324e0a722c20bdb4c20ee39bf1c30ce8ae499c8502b0b5e0c6"
  end

  resource "openai" do
    url "https://files.pythonhosted.org/packages/a3/77/5172104ca1df35ed2ed8fb26dbc787f721c39498fc51d666c4db07756a0c/openai-1.66.3.tar.gz"
    sha256 "8dde3aebe2d081258d4159c4cb27bdc13b5bb3f7ea2201d9bd940b9a89faf0c9"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/ca/bc/f35b8446f4531a7cb215605d100cd88b7ac6f44ab3fc94870c120ab3adbf/pathspec-0.12.1.tar.gz"
    sha256 "a482d51503a1ab33b1c67a6c3813a26953dbdc71c31dacaef9a838c4e29f5712"
  end

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/42/92/cc564bf6381ff43ce1f4d06852fc19a2f11d180f23dc32d9588bee2f149d/pexpect-4.9.0.tar.gz"
    sha256 "ee7d41123f3c9911050ea2c2dac107568dc43b2d3b0c7557a33212c398ead30f"
  end

  resource "posthog" do
    url "https://files.pythonhosted.org/packages/70/c7/1cf4f3c10259057ac59d2a6b18c9251ff6d856e3424fbdbee9a6fc052db1/posthog-3.19.1.tar.gz"
    sha256 "b879bc257de287ea91a9545bab1a3d09ba22586f3c0370ef210e06631c4929bc"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/a1/e1/bd15cb8ffdcfeeb2bdc215de3c3cffca11408d829e4b8416dcfe71ba8854/prompt_toolkit-3.0.50.tar.gz"
    sha256 "544748f3860a2623ca5cd6d2795e7a14f3d0e1c3c9728359013f79877fc89bab"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/92/76/f941e63d55c0293ff7829dd21e7cf1147e90a526756869a9070f287a68c9/propcache-0.3.0.tar.gz"
    sha256 "a8fd93de4e1d278046345f49e2238cdb298589325849b2645d4a94c53faeffc5"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/2a/80/336820c1ad9286a4ded7e845b2eccfcb27851ab8ac6abece774a6ff4d3de/psutil-7.0.0.tar.gz"
    sha256 "7be9c3eba38beccb6495ea33afd982a44074b78f28c434a1f51cc07fd315c456"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/20/e5/16ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4e/ptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "pycodestyle" do
    url "https://files.pythonhosted.org/packages/43/aa/210b2c9aedd8c1cbeea31a50e42050ad56187754b34eb214c46709445801/pycodestyle-2.12.1.tar.gz"
    sha256 "6838eae08bbce4f6accd5d5572075c63626a15ee3e6f842df996bf62f6d73521"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/1d/b2/31537cf4b1ca988837256c910a668b553fceb8f069bedc4b1c826024b52c/pycparser-2.22.tar.gz"
    sha256 "491c8be9c040f5390f5bf44a5b07752bd07f56edf992381b05c701439eec10f6"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/b7/ae/d5220c5c52b158b1de7ca89fc5edb72f304a70a4c540c84c8844bf4008de/pydantic-2.10.6.tar.gz"
    sha256 "ca5daa827cce33de7a42be142548b0096bf05a7e7b365aebfa5f8eeec7128236"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/fc/01/f3e5ac5e7c25833db5eb555f7b7ab24cd6f8c322d3a3ad2d67a952dc0abc/pydantic_core-2.27.2.tar.gz"
    sha256 "eb026e5a4c1fee05726072337ff51d1efb6f59090b7da90d30ea58625b1ffb39"
  end

  resource "pydub" do
    url "https://files.pythonhosted.org/packages/fe/9a/e6bca0eed82db26562c73b5076539a4a08d3cffd19c3cc5913a3e61145fd/pydub-0.25.1.tar.gz"
    sha256 "980a33ce9949cab2a569606b65674d748ecbca4f0796887fd6f46173a7b0d30f"
  end

  resource "pyflakes" do
    url "https://files.pythonhosted.org/packages/57/f9/669d8c9c86613c9d568757c7f5824bd3197d7b1c6c27553bc5618a27cce2/pyflakes-3.2.0.tar.gz"
    sha256 "1c61603ff154621fb2a9172037d84dca3500def8c8b630657d1701f026f8af3f"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/7c/2d/c3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84/pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "pypandoc" do
    url "https://files.pythonhosted.org/packages/e1/88/26e650d053df5f3874aa3c05901a14166ce3271f58bfe114fd776987efbd/pypandoc-1.15.tar.gz"
    sha256 "ea25beebe712ae41d63f7410c08741a3cab0e420f6703f95bc9b3a749192ce13"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/30/23/2f0a3efc4d6a32f3b63cdff36cd398d9701d26cda58e3ab97ac79fb5e60d/pyperclip-1.9.0.tar.gz"
    sha256 "b7de0142ddc81bfc5c7507eea19da920b92252b548b96186caf94a5e2527d310"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/bc/57/e84d88dfe0aec03b7a2d4327012c1627ab5f03652216c63d49846d7a6c58/python-dotenv-1.0.1.tar.gz"
    sha256 "e324ee90a023d808f1959c46bcbc04446a10ced277783dc6ee09987c37ec10ca"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/2f/db/98b5c277be99dd18bfd91dd04e1b759cad18d1a338188c936e92f921c7e2/referencing-0.36.2.tar.gz"
    sha256 "df2e89862cd09deabbdba16944cc3f10feb6b3e6f18e902f7cc25609a34775aa"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/8e/5f/bd69653fbfb76cf8604468d3b4ec4c403197144c7bfe0e6a5fc9e02a07cb/regex-2024.11.6.tar.gz"
    sha256 "7ab159b063c52a0333c884e4679f8d7a85112ee3078fe3d9004b2dd875585519"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/ab/3a/0316b28d0761c6734d6bc14e770d85506c986c85ffb239e688eeaab2c2bc/rich-13.9.4.tar.gz"
    sha256 "439594978a49a09530cff7ebc4b5c7103ef57baf48d5ea3184f21d9a2befa098"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/0a/79/2ce611b18c4fd83d9e3aecb5cba93e1917c050f556db39842889fa69b79f/rpds_py-0.23.1.tar.gz"
    sha256 "7f3240dcfa14d198dba24b8b9cb3b108c06b68d45b7babd9eefc1038fdf7e707"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/32/d2/7b171caf085ba0d40d8391f54e1c75a1cda9255f542becf84575cfd8a732/setuptools-76.0.0.tar.gz"
    sha256 "43b4ee60e10b0d0ee98ad11918e114c70701bc6051662a9a675a0496c1a158f4"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/44/cd/a040c4b3119bbe532e5b0732286f805445375489fceaec1f48306068ee3b/smmap-5.0.2.tar.gz"
    sha256 "26ea65a03958fa0c8a1c7e8c7a58fdc77221b8910f6be2131affade476898ad5"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "socksio" do
    url "https://files.pythonhosted.org/packages/f8/5c/48a7d9495be3d1c651198fd99dbb6ce190e2274d0f28b9051307bdec6b85/socksio-1.0.0.tar.gz"
    sha256 "f88beb3da5b5c38b9890469de67d0cb0f9d494b78b106ca1845f96c10b91c4ac"
  end

  resource "sounddevice" do
    url "https://files.pythonhosted.org/packages/80/2d/b04ae180312b81dbb694504bee170eada5372242e186f6298139fd3a0513/sounddevice-0.5.1.tar.gz"
    sha256 "09ca991daeda8ce4be9ac91e15a9a81c8f81efa6b695a348c9171ea0c16cb041"
  end

  resource "soundfile" do
    url "https://files.pythonhosted.org/packages/e1/41/9b873a8c055582859b239be17902a85339bec6a30ad162f98c9b0288a2cc/soundfile-0.13.1.tar.gz"
    sha256 "b2c68dab1e30297317080a5b43df57e302584c49e2942defdde0acccc53f0e5b"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/d7/ce/fbaeed4f9fb8b2daa961f90591662df6a86c1abf25c548329a86920aedfb/soupsieve-2.6.tar.gz"
    sha256 "e2e68417777af359ec65daac1057404a3c8a5455bb8abc36f1a9866ab1a51abb"
  end

  resource "tiktoken" do
    url "https://files.pythonhosted.org/packages/ea/cf/756fedf6981e82897f2d570dd25fa597eb3f4459068ae0572d7e888cfd6f/tiktoken-0.9.0.tar.gz"
    sha256 "d02a5ca6a938e0490e1ff957bc48c8b078c88cb83977be1625b1fd8aac792c5d"
  end

  resource "tokenizers" do
    url "https://files.pythonhosted.org/packages/20/41/c2be10975ca37f6ec40d7abd7e98a5213bb04f284b869c1a24e6504fd94d/tokenizers-0.21.0.tar.gz"
    sha256 "ee0894bf311b75b0c03079f33859ae4b2334d675d4e93f5a4132e1eae2834fe4"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/a8/4b/29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744d/tqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  resource "tree-sitter" do
    url "https://files.pythonhosted.org/packages/39/9e/b7cb190aa08e4ea387f2b1531da03efb4b8b033426753c0b97e3698645f6/tree-sitter-0.21.3.tar.gz"
    sha256 "b5de3028921522365aa864d95b3c41926e0ba6a85ee5bd000e10dc49b0766988"
  end

  # sdist issue report, https://github.com/grantjenks/py-tree-sitter-languages/issues/63
  resource "tree-sitter-languages" do
    url "https://github.com/grantjenks/py-tree-sitter-languages/archive/refs/tags/v1.10.2.tar.gz"
    sha256 "cdd03196ebaf8f486db004acd07a5b39679562894b47af6b20d28e4aed1a6ab5"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/aa/63/e53da845320b757bf29ef6a9062f5c669fe997973f966045cb019c3f4b66/urllib3-2.3.0.tar.gz"
    sha256 "f8c5449b3cf0861679ce7e0503c7b44b5ec981bec0d1d3795a07f1ba96f0204d"
  end

  resource "watchfiles" do
    url "https://files.pythonhosted.org/packages/f5/26/c705fc77d0a9ecdb9b66f1e2976d95b81df3cae518967431e7dbf9b5e219/watchfiles-1.0.4.tar.gz"
    sha256 "6ba473efd11062d73e4f00c2b730255f9c1bdd73cd5f9fe5b5da8dbd4a717205"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/b7/9d/4b94a8e6d2b51b599516a5cb88e5bc99b4d8d4583e468057eaa29d5f0918/yarl-1.18.3.tar.gz"
    sha256 "ac1801c45cbf77b6c99242eeff4fffb5e4e73a800b5c4ad4fc0be5def634d2e1"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/3f/50/bad581df71744867e9468ebd0bcd6505de3b275e06f202c2cb016e3ff56f/zipp-3.21.0.tar.gz"
    sha256 "2c9958f6430a2040341a52eb608ed6dd93ef4392e02ffe219417c1b28b5dd1f4"
  end

  def python3
    "python3.12"
  end

  def install
    venv = virtualenv_install_with_resources without: "tree-sitter-languages"

    # Requires building languages outside `setup.py`: https://github.com/grantjenks/py-tree-sitter-languages/pull/65
    resource("tree-sitter-languages").stage do
      ENV.prepend_path "PYTHONPATH", Formula["cython"].opt_libexec/Language::Python.site_packages(python3)
      system venv.root/"bin/python", "build.py"
      venv.pip_install Pathname.pwd
    end
  end

  test do
    mkdir "tmptestdir" do
      assert_match version.to_s, shell_output("#{bin}/aider --version")
      output = shell_output("#{bin}/aider --yes --exit --no-check-update 2>&1", 1)
      assert_match "You need to specify a --model and an --api-key to use", output
      ENV["OPENAI_API_KEY"] = "invalid"
      output = shell_output("#{bin}/aider --yes --exit --message=test --no-check-update 2>&1")
      assert_match "API key provided: invalid", output
    end
  end
end
