class Aspell < Formula
  desc "Spell checker with better logic than ispell"
  homepage "http://aspell.net/"
  url "https://ftp.gnu.org/gnu/aspell/aspell-0.60.8.tar.gz"
  mirror "https://ftpmirror.gnu.org/aspell/aspell-0.60.8.tar.gz"
  sha256 "f9b77e515334a751b2e60daab5db23499e26c9209f5e7b7443b05235ad0226f2"
  license "LGPL-2.1-only"

  bottle do
    rebuild 1
    sha256 arm64_monterey: "d75d3b4e2929123244786e9adb7ff335ec75943617e7dbd855d71c7ce3035173"
    sha256 arm64_big_sur:  "bdd761d4454523f1bc8c0adba2db1a23c215c01371e348cd162b573347791159"
    sha256 monterey:       "91f9e3083f86a059d0db046aa78e3ddf95a3c6cf531c982b7ca470dd0e57db3b"
    sha256 big_sur:        "abf04f9f474e21d070e22667204cd122e7e099e90e60110dc7639fdaa5f5a66f"
    sha256 catalina:       "86b7d31eff12742ccb73464c088c8313998bd4c1e37f108754f936d51b6f49dd"
    sha256 mojave:         "aeded9b9861145353ad13bbf85772f23e556fe6dc0b263beebd555cf19762197"
    sha256 x86_64_linux:   "5154c4a1e76b1f9ab21325d442cd9eaf80b83314792142ff837f84bcfb8cbb4a"
  end

  uses_from_macos "ncurses"

  resource "en" do
    url "https://ftp.gnu.org/gnu/aspell/dict/en/aspell6-en-2018.04.16-0.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/en/aspell6-en-2018.04.16-0.tar.bz2"
    sha256 "f11071e74b0c0753f4afabf024941a5c3a96bafe3879211ebd47bc34e76fbd2f"
  end

  resource "de" do
    url "https://ftp.gnu.org/gnu/aspell/dict/de/aspell6-de-20161207-7-0.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/de/aspell6-de-20161207-7-0.tar.bz2"
    sha256 "c2125d1fafb1d4effbe6c88d4e9127db59da9ed92639c7cbaeae1b7337655571"
  end

  resource "es" do
    url "https://ftp.gnu.org/gnu/aspell/dict/es/aspell6-es-1.11-2.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/es/aspell6-es-1.11-2.tar.bz2"
    sha256 "ad367fa1e7069c72eb7ae37e4d39c30a44d32a6aa73cedccbd0d06a69018afcc"
  end

  resource "fr" do
    url "https://ftp.gnu.org/gnu/aspell/dict/fr/aspell-fr-0.50-3.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/fr/aspell-fr-0.50-3.tar.bz2"
    sha256 "f9421047519d2af9a7a466e4336f6e6ea55206b356cd33c8bd18cb626bf2ce91"
  end

  resource "af" do
    url "https://ftp.gnu.org/gnu/aspell/dict/af/aspell-af-0.50-0.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/af/aspell-af-0.50-0.tar.bz2"
    sha256 "9d6000aeca5911343278bd6ed9e21d42c8cb26247dafe94a76ff81d8ac98e602"
  end

  resource "am" do
    url "https://ftp.gnu.org/gnu/aspell/dict/am/aspell6-am-0.03-1.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/am/aspell6-am-0.03-1.tar.bz2"
    sha256 "bf27dd21f8871e2b3332c211b402cd46604d431a7773e599729c242cdfb9d487"
  end

  resource "ar" do
    url "https://ftp.gnu.org/gnu/aspell/dict/ar/aspell6-ar-1.2-0.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/ar/aspell6-ar-1.2-0.tar.bz2"
    sha256 "041ea24a82cdd6957040e2fb84262583bf46b3a8301283a75d257a7417207cab"
  end

  resource "ast" do
    url "https://ftp.gnu.org/gnu/aspell/dict/ast/aspell6-ast-0.01.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/ast/aspell6-ast-0.01.tar.bz2"
    sha256 "43f23ed01c338c37f9bbb820db757b36ede1cea47a7b93dc8b6d7bd66b410f92"
  end

  resource "az" do
    url "https://ftp.gnu.org/gnu/aspell/dict/az/aspell6-az-0.02-0.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/az/aspell6-az-0.02-0.tar.bz2"
    sha256 "063176ec459d61acd59450ae49b5076e42abb1dcd54c1f934bae5fa6658044c3"
  end

  resource "be" do
    url "https://ftp.gnu.org/gnu/aspell/dict/be/aspell5-be-0.01.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/be/aspell5-be-0.01.tar.bz2"
    sha256 "550bad0c03a142241ffe5ecc183659d80020b566003a05341cd1e97c6ed274eb"
  end

  resource "bg" do
    url "https://ftp.gnu.org/gnu/aspell/dict/bg/aspell6-bg-4.1-0.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/bg/aspell6-bg-4.1-0.tar.bz2"
    sha256 "74570005dc2be5a244436fa2b46a5f612be84c6843f881f0cb1e4c775f658aaa"
  end

  resource "bn" do
    url "https://ftp.gnu.org/gnu/aspell/dict/bn/aspell6-bn-0.01.1-1.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/bn/aspell6-bn-0.01.1-1.tar.bz2"
    sha256 "b03f9cc4feb00df9bfd697b032f4f4ae838ad5a6bb41db798eefc5639a1480d9"
  end

  resource "br" do
    url "https://ftp.gnu.org/gnu/aspell/dict/br/aspell-br-0.50-2.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/br/aspell-br-0.50-2.tar.bz2"
    sha256 "c2122a6dcca653c082d785f0da4bf267363182a017fea4129e8b0882aa6d2a3b"
  end

  resource "ca" do
    url "https://ftp.gnu.org/gnu/aspell/dict/ca/aspell6-ca-2.1.5-1.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/ca/aspell6-ca-2.1.5-1.tar.bz2"
    sha256 "ebdae47edf87357a4df137dd754737e6417452540cb1ed34b545ccfd66f165b9"
  end

  resource "cs" do
    url "https://ftp.gnu.org/gnu/aspell/dict/cs/aspell6-cs-20040614-1.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/cs/aspell6-cs-20040614-1.tar.bz2"
    sha256 "01c091f907c2fa4dfa38305c2494bb80009407dfb76ead586ad724ae21913066"
  end

  resource "csb" do
    url "https://ftp.gnu.org/gnu/aspell/dict/csb/aspell6-csb-0.02-0.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/csb/aspell6-csb-0.02-0.tar.bz2"
    sha256 "c166ad07d50e9e13ac9f87d5a8938b3f675a0f8a01017bd8969c2053e7f52298"
  end

  resource "cy" do
    url "https://ftp.gnu.org/gnu/aspell/dict/cy/aspell-cy-0.50-3.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/cy/aspell-cy-0.50-3.tar.bz2"
    sha256 "d5399dcd70061e5ed5af1214eb580f62864dd35ea4fa1ec2882ffc4f03307897"
  end

  resource "da" do
    url "https://ftp.gnu.org/gnu/aspell/dict/da/aspell6-da-1.6.36-11-0.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/da/aspell6-da-1.6.36-11-0.tar.bz2"
    sha256 "dbc6cbceaa7a4528f3756f0b5cce5c3d0615c2103d3899b47e9df2ed9582e2f7"
  end

  resource "de_alt" do
    url "https://ftp.gnu.org/gnu/aspell/dict/de-alt/aspell6-de-alt-2.1-1.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/de-alt/aspell6-de-alt-2.1-1.tar.bz2"
    sha256 "36d13c6c743a6b1ff05fb1af79134e118e5a94db06ba40c076636f9d04158c73"
  end

  resource "el" do
    url "https://ftp.gnu.org/gnu/aspell/dict/el/aspell6-el-0.08-0.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/el/aspell6-el-0.08-0.tar.bz2"
    sha256 "4af60f1a8adf8b1899680deefdf49288d7406a2c591658f880628bf7c1604cd2"
  end

  resource "eo" do
    url "https://ftp.gnu.org/gnu/aspell/dict/eo/aspell6-eo-2.1.20000225a-2.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/eo/aspell6-eo-2.1.20000225a-2.tar.bz2"
    sha256 "41d2d18d6a4de6422185a31ecfc1a3de2e751f3dfb2cbec8f275b11857056e27"
  end

  resource "et" do
    url "https://ftp.gnu.org/gnu/aspell/dict/et/aspell6-et-0.1.21-1.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/et/aspell6-et-0.1.21-1.tar.bz2"
    sha256 "b1e857aa3daaea2a19462b2671e87c26a7eb7337c83b709685394eed8472b249"
  end

  resource "fa" do
    url "https://ftp.gnu.org/gnu/aspell/dict/fa/aspell6-fa-0.11-0.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/fa/aspell6-fa-0.11-0.tar.bz2"
    sha256 "482d26ea879a8ea02d9373952205f67e07c85a7550841b13b5079bb2f9f2e15b"
  end

  resource "fi" do
    url "https://ftp.gnu.org/gnu/aspell/dict/fi/aspell6-fi-0.7-0.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/fi/aspell6-fi-0.7-0.tar.bz2"
    sha256 "f8d7f07b4511e606eb56392ddaa76fd29918006331795e5942ad11b510d0a51d"
  end

  resource "fo" do
    url "https://ftp.gnu.org/gnu/aspell/dict/fo/aspell5-fo-0.2.16-1.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/fo/aspell5-fo-0.2.16-1.tar.bz2"
    sha256 "f7e0ddc039bb4f5c142d39dab72d9dfcb951f5e46779f6e3cf1d084a69f95e08"
  end

  resource "fy" do
    url "https://ftp.gnu.org/gnu/aspell/dict/fy/aspell6-fy-0.12-0.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/fy/aspell6-fy-0.12-0.tar.bz2"
    sha256 "3447cfa90e459af32183a6bc8af9ba3ed571087811cdfc336821454bac8995aa"
  end

  resource "ga" do
    url "https://ftp.gnu.org/gnu/aspell/dict/ga/aspell5-ga-4.5-0.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/ga/aspell5-ga-4.5-0.tar.bz2"
    sha256 "455fdbbca24cecb4667fbcf9544d84ae83e5b2505caae79afa6b2cb76b4d0679"
  end

  resource "gd" do
    url "https://ftp.gnu.org/gnu/aspell/dict/gd/aspell5-gd-0.1.1-1.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/gd/aspell5-gd-0.1.1-1.tar.bz2"
    sha256 "e316a08a75da8a0d4d15eb892023073a971e0a326382a5532db29856768e0929"
  end

  resource "gl" do
    url "https://ftp.gnu.org/gnu/aspell/dict/gl/aspell6-gl-0.5a-2.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/gl/aspell6-gl-0.5a-2.tar.bz2"
    sha256 "b3cdcf65971e70b8c09fb7f319164c6344a80d260b6e98dc6ecca1e02b7cfc8a"
  end

  resource "grc" do
    url "https://ftp.gnu.org/gnu/aspell/dict/grc/aspell6-grc-0.02-0.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/grc/aspell6-grc-0.02-0.tar.bz2"
    sha256 "2214883e2b9883f360b090948afd2cb0687bc6bba4e1e98011fb8c8d4a42b9ff"
  end

  resource "gu" do
    url "https://ftp.gnu.org/gnu/aspell/dict/gu/aspell6-gu-0.03-0.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/gu/aspell6-gu-0.03-0.tar.bz2"
    sha256 "432c125acc6a86456061dcd47018df4318a117be9f7c09a590979243ad448311"
  end

  resource "gv" do
    url "https://ftp.gnu.org/gnu/aspell/dict/gv/aspell-gv-0.50-0.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/gv/aspell-gv-0.50-0.tar.bz2"
    sha256 "bbe626feb5c81c1b7e7d3199d558bc5c560b2d4aef377d0e4b4227ae3c7176e6"
  end

  resource "he" do
    url "https://ftp.gnu.org/gnu/aspell/dict/he/aspell6-he-1.0-0.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/he/aspell6-he-1.0-0.tar.bz2"
    sha256 "d64dabac9f40ca9e632a8eee40fc01c7d18a2c699d8f9742000fadd2e15b708d"
  end

  resource "hi" do
    url "https://ftp.gnu.org/gnu/aspell/dict/hi/aspell6-hi-0.02-0.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/hi/aspell6-hi-0.02-0.tar.bz2"
    sha256 "da0778c46716f4209da25195294139c2f5e6031253381afa4f81908fc9193a37"
  end

  resource "hil" do
    url "https://ftp.gnu.org/gnu/aspell/dict/hil/aspell5-hil-0.11-0.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/hil/aspell5-hil-0.11-0.tar.bz2"
    sha256 "570a374fd0b97943bc6893cf25ac7b23da815120842a80144e2c7ee8b41388e8"
  end

  resource "hr" do
    url "https://ftp.gnu.org/gnu/aspell/dict/hr/aspell-hr-0.51-0.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/hr/aspell-hr-0.51-0.tar.bz2"
    sha256 "2ac4030354d7961e45d63b46e06e59248d59cc70dfc9e1d8ee0ae21d9c774a25"
  end

  resource "hsb" do
    url "https://ftp.gnu.org/gnu/aspell/dict/hsb/aspell6-hsb-0.02-0.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/hsb/aspell6-hsb-0.02-0.tar.bz2"
    sha256 "8d9f2ae428c7754a922ce6a7ef23401bc65f6f1909aec5077975077b3edc222e"
  end

  resource "hu" do
    url "https://ftp.gnu.org/gnu/aspell/dict/hu/aspell6-hu-0.99.4.2-0.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/hu/aspell6-hu-0.99.4.2-0.tar.bz2"
    sha256 "3335a7b45cf9774bccf03740fbddeb7ec4752dd87178fa93f92d4c71e3f236b5"
  end

  resource "hus" do
    url "https://ftp.gnu.org/gnu/aspell/dict/hus/aspell6-hus-0.03-1.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/hus/aspell6-hus-0.03-1.tar.bz2"
    sha256 "6d28f371d1a172439395d56d2d5ce8f27c617de03f847f02643dfd79dd8df425"
  end

  resource "hy" do
    url "https://ftp.gnu.org/gnu/aspell/dict/hy/aspell6-hy-0.10.0-0.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/hy/aspell6-hy-0.10.0-0.tar.bz2"
    sha256 "2dea8d0093a3b8373cc97703dca2979b285f71916181d1a20db70bea28c2bcf0"
  end

  resource "ia" do
    url "https://ftp.gnu.org/gnu/aspell/dict/ia/aspell-ia-0.50-1.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/ia/aspell-ia-0.50-1.tar.bz2"
    sha256 "5797cb59606d007cf8fe5b9ec435de0d63b2d0e0d391ed8850ef8aa3f4bb0c2f"
  end

  resource "id" do
    url "https://ftp.gnu.org/gnu/aspell/dict/id/aspell5-id-1.2-0.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/id/aspell5-id-1.2-0.tar.bz2"
    sha256 "523912082848d891746dbb233f2ddb2cdbab6750dc76c38b3f6e000c9eb37308"
  end

  resource "it" do
    url "https://ftp.gnu.org/gnu/aspell/dict/it/aspell6-it-2.2_20050523-0.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/it/aspell6-it-2.2_20050523-0.tar.bz2"
    sha256 "3b19dc709924783c8d87111aa9653dc6c000e845183778abee750215d83aaebd"
  end

  resource "kn" do
    url "https://ftp.gnu.org/gnu/aspell/dict/kn/aspell6-kn-0.01-1.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/kn/aspell6-kn-0.01-1.tar.bz2"
    sha256 "cb010b34a712f853fa53c4618cb801704b9f76c72db9390009ba914e3a075383"
  end

  resource "ku" do
    url "https://ftp.gnu.org/gnu/aspell/dict/ku/aspell5-ku-0.20-1.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/ku/aspell5-ku-0.20-1.tar.bz2"
    sha256 "968f76418c991dc004a1cc3d8cd07b58fb210b6ad506106857ed2d97274a6a27"
  end

  resource "ky" do
    url "https://ftp.gnu.org/gnu/aspell/dict/ky/aspell6-ky-0.01-0.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/ky/aspell6-ky-0.01-0.tar.bz2"
    sha256 "e10f2f25b44b71e30fa1ea9c248c04543c688845a734d0b9bdc65a2bbd16fb4f"
  end

  resource "la" do
    url "https://ftp.gnu.org/gnu/aspell/dict/la/aspell6-la-20020503-0.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/la/aspell6-la-20020503-0.tar.bz2"
    sha256 "d486b048d1c3056d3a555744584a81873a63ecd4641f04e8b7bf9910b98d2985"
  end

  resource "lt" do
    url "https://ftp.gnu.org/gnu/aspell/dict/lt/aspell6-lt-1.2.1-0.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/lt/aspell6-lt-1.2.1-0.tar.bz2"
    sha256 "f6f53b6e418c22f63e1a70b8bc77bc66912bc1afd40cf98dc026d110d26452ab"
  end

  resource "lv" do
    url "https://ftp.gnu.org/gnu/aspell/dict/lv/aspell6-lv-0.5.5-1.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/lv/aspell6-lv-0.5.5-1.tar.bz2"
    sha256 "3c30e206ea562b2e759fb7467680e1a01d5deec5edbd66653c83184550d1fb8a"
  end

  resource "mg" do
    url "https://ftp.gnu.org/gnu/aspell/dict/mg/aspell5-mg-0.03-0.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/mg/aspell5-mg-0.03-0.tar.bz2"
    sha256 "5182f832e1630ceef5711a83b530fb583ffe04f28cc042d195b5c6b2d25cb041"
  end

  resource "mi" do
    url "https://ftp.gnu.org/gnu/aspell/dict/mi/aspell-mi-0.50-0.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/mi/aspell-mi-0.50-0.tar.bz2"
    sha256 "beee1e33baf6301e3ffc56558c84c3e7d29622541b232c1aea1e91d12ebd7d89"
  end

  resource "mk" do
    url "https://ftp.gnu.org/gnu/aspell/dict/mk/aspell-mk-0.50-0.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/mk/aspell-mk-0.50-0.tar.bz2"
    sha256 "15fc2380fb673d2003d8075d8cef2b0dbb4d30b430587ad459257681904d9971"
  end

  resource "ml" do
    url "https://ftp.gnu.org/gnu/aspell/dict/ml/aspell6-ml-0.03-1.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/ml/aspell6-ml-0.03-1.tar.bz2"
    sha256 "e4cd551e558b6d26e4db58e051eeca3d893fc2c4e7fce90a022af247422096fd"
  end

  resource "mn" do
    url "https://ftp.gnu.org/gnu/aspell/dict/mn/aspell6-mn-0.06-2.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/mn/aspell6-mn-0.06-2.tar.bz2"
    sha256 "2f1b6edd48b82cd9b99b9262d5635f72271c062ef4e772b90388dfc48a4f1294"
  end

  resource "mr" do
    url "https://ftp.gnu.org/gnu/aspell/dict/mr/aspell6-mr-0.10-0.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/mr/aspell6-mr-0.10-0.tar.bz2"
    sha256 "d3a35a40bee0234a5b388375485ab8bf0ba8edbf3b0a82e2c2f76a40a8586f33"
  end

  resource "ms" do
    url "https://ftp.gnu.org/gnu/aspell/dict/ms/aspell-ms-0.50-0.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/ms/aspell-ms-0.50-0.tar.bz2"
    sha256 "3cc4e3537bb0f455ce58b4d2fa84b03dc678e0153536a41dee1a3a7623dc246f"
  end

  resource "mt" do
    url "https://ftp.gnu.org/gnu/aspell/dict/mt/aspell-mt-0.50-0.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/mt/aspell-mt-0.50-0.tar.bz2"
    sha256 "e00fcaad60a90cfed687ba02f62be8c27b8650457dd3c5bdcb064b476da059b4"
  end

  resource "nds" do
    url "https://ftp.gnu.org/gnu/aspell/dict/nds/aspell6-nds-0.01-0.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/nds/aspell6-nds-0.01-0.tar.bz2"
    sha256 "ce381e869def56e54a31f965df518deca0e6f12238859650fcb115623f8772da"
  end

  resource "nl" do
    url "https://ftp.gnu.org/gnu/aspell/dict/nl/aspell-nl-0.50-2.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/nl/aspell-nl-0.50-2.tar.bz2"
    sha256 "440e0b7df8c5903d728221fe4ba88a74658ce14c8bb04b290c41402dfd41cb39"
  end

  resource "nn" do
    url "https://ftp.gnu.org/gnu/aspell/dict/nn/aspell-nn-0.50.1-1.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/nn/aspell-nn-0.50.1-1.tar.bz2"
    sha256 "ac6610540c7e134f09cbebbd148f9316bef27bc491e377638ef4e2950b2d5370"
  end

  resource "ny" do
    url "https://ftp.gnu.org/gnu/aspell/dict/ny/aspell5-ny-0.01-0.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/ny/aspell5-ny-0.01-0.tar.bz2"
    sha256 "176f970f6ba3bb448c7e946fa8d209eb4da7138ac6899af7731a98c7b6484b3e"
  end

  resource "or" do
    url "https://ftp.gnu.org/gnu/aspell/dict/or/aspell6-or-0.03-1.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/or/aspell6-or-0.03-1.tar.bz2"
    sha256 "d6ffa369f8918d74cdea966112bc5cb700e09dca5ac6b968660cfc22044ef24f"
  end

  resource "pa" do
    url "https://ftp.gnu.org/gnu/aspell/dict/pa/aspell6-pa-0.01-1.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/pa/aspell6-pa-0.01-1.tar.bz2"
    sha256 "c7f3abb1c5efe62e072ca8bef44b0d0506501bbb7b48ced1d0d95f10e61fc945"
  end

  resource "pl" do
    url "https://ftp.gnu.org/gnu/aspell/dict/pl/aspell6-pl-6.0_20061121-0.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/pl/aspell6-pl-6.0_20061121-0.tar.bz2"
    sha256 "017741fcb70a885d718c534160c9de06b03cc72f352879bd106be165e024574d"
  end

  resource "pt_BR" do
    url "https://ftp.gnu.org/gnu/aspell/dict/pt_BR/aspell6-pt_BR-20131030-12-0.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/pt_BR/aspell6-pt_BR-20131030-12-0.tar.bz2"
    sha256 "eb0d99db0b5d5c442133a88bddfe96dd252c0c3df3da36e9326c241dc4bc14f7"
  end

  resource "pt_PT" do
    url "https://ftp.gnu.org/gnu/aspell/dict/pt_PT/aspell6-pt_PT-20190329-1-0.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/pt_PT/aspell6-pt_PT-20190329-1-0.tar.bz2"
    sha256 "e5708b890c2afff51276a6cc276af5e6b3b8a026db75eda48b58124f2368a051"
  end

  resource "qu" do
    url "https://ftp.gnu.org/gnu/aspell/dict/qu/aspell6-qu-0.02-0.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/qu/aspell6-qu-0.02-0.tar.bz2"
    sha256 "80977629b8425bda7ffd951628d23a6793a457f4948151c71ff9e0bff5073f01"
  end

  resource "ro" do
    url "https://ftp.gnu.org/gnu/aspell/dict/ro/aspell5-ro-3.3-2.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/ro/aspell5-ro-3.3-2.tar.bz2"
    sha256 "53c38b7668a540cf90ddca11c007ce812d2ad86bd11c2c43a08da9e06392683d"
  end

  resource "ru" do
    url "https://ftp.gnu.org/gnu/aspell/dict/ru/aspell6-ru-0.99f7-1.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/ru/aspell6-ru-0.99f7-1.tar.bz2"
    sha256 "5c29b6ccce57bc3f7c4fb0510d330446b9c769e59c92bdfede27333808b6e646"
  end

  resource "rw" do
    url "https://ftp.gnu.org/gnu/aspell/dict/rw/aspell-rw-0.50-0.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/rw/aspell-rw-0.50-0.tar.bz2"
    sha256 "3406102e0e33344b6eae73dbfaf86d8e411b7c97775827a6db79c943ce43f081"
  end

  resource "sc" do
    url "https://ftp.gnu.org/gnu/aspell/dict/sc/aspell5-sc-1.0.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/sc/aspell5-sc-1.0.tar.bz2"
    sha256 "591ae22f712b472182b41b8bc97dce1e5ecd240c75eccc25f59ab15c60be8742"
  end

  resource "sk" do
    url "https://ftp.gnu.org/gnu/aspell/dict/sk/aspell6-sk-2.01-2.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/sk/aspell6-sk-2.01-2.tar.bz2"
    sha256 "c6a80a2989c305518e0d71af1196b7484fda26fe53be4e49eec7b15b76a860a6"
  end

  resource "sl" do
    url "https://ftp.gnu.org/gnu/aspell/dict/sl/aspell-sl-0.50-0.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/sl/aspell-sl-0.50-0.tar.bz2"
    sha256 "e566d127f7130da2df7b1f4f4cb4bc51932517b0c24299f84498ba325e6133d1"
  end

  resource "sr" do
    url "https://ftp.gnu.org/gnu/aspell/dict/sr/aspell6-sr-0.02.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/sr/aspell6-sr-0.02.tar.bz2"
    sha256 "705e58fb390633c89c4cb224a1cfb34e67e09496448f7adc6500494b6e009289"
  end

  resource "sv" do
    url "https://ftp.gnu.org/gnu/aspell/dict/sv/aspell-sv-0.51-0.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/sv/aspell-sv-0.51-0.tar.bz2"
    sha256 "9b70573c9c8cf76f5cdb6abcdfb834a754bbaa1efd7d6f57f47b8a91a19c5c0a"
  end

  resource "sw" do
    url "https://ftp.gnu.org/gnu/aspell/dict/sw/aspell-sw-0.50-0.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/sw/aspell-sw-0.50-0.tar.bz2"
    sha256 "7ed51f107dc57a7b3555f20d1cee2903275d63e022b055ea6b6409d9e081f297"
  end

  resource "ta" do
    url "https://ftp.gnu.org/gnu/aspell/dict/ta/aspell6-ta-20040424-1.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/ta/aspell6-ta-20040424-1.tar.bz2"
    sha256 "52f552f1a2c0fc53ed4eac75990ff75bccf3d5f1440ca3d948d96eafe5f3486a"
  end

  resource "te" do
    url "https://ftp.gnu.org/gnu/aspell/dict/te/aspell6-te-0.01-2.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/te/aspell6-te-0.01-2.tar.bz2"
    sha256 "3682638a757a65afcc770e565e68347e8eb7be94052d9d6eff64fc767e7fec5d"
  end

  resource "tet" do
    url "https://ftp.gnu.org/gnu/aspell/dict/tet/aspell5-tet-0.1.1.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/tet/aspell5-tet-0.1.1.tar.bz2"
    sha256 "9dd546c9c48f42085e3c17f22c8e6d46e56f3ea9c4618b933c642a091df1c09e"
  end

  resource "tk" do
    url "https://ftp.gnu.org/gnu/aspell/dict/tk/aspell5-tk-0.01-0.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/tk/aspell5-tk-0.01-0.tar.bz2"
    sha256 "86f24209cab61a54ed85ad3020915d8ce1dec13fbfe012f1bf1d648825696a0b"
  end

  resource "tl" do
    url "https://ftp.gnu.org/gnu/aspell/dict/tl/aspell5-tl-0.02-1.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/tl/aspell5-tl-0.02-1.tar.bz2"
    sha256 "48b65d2c6886f353d1e1756a93bcd4d8ab2b88b021176c25dfdb5d8bcf348acd"
  end

  resource "tn" do
    url "https://ftp.gnu.org/gnu/aspell/dict/tn/aspell5-tn-1.0.1-0.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/tn/aspell5-tn-1.0.1-0.tar.bz2"
    sha256 "41a0c20e1d2acaa28a647d74b40778e491815566019f79e7049621f40d3bbd60"
  end

  resource "tr" do
    url "https://ftp.gnu.org/gnu/aspell/dict/tr/aspell-tr-0.50-0.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/tr/aspell-tr-0.50-0.tar.bz2"
    sha256 "0bc6530e5eebf8b2b53f1e8add596c62099173f62b9baa6b3efaa86752bdfb4a"
  end

  resource "uk" do
    url "https://ftp.gnu.org/gnu/aspell/dict/uk/aspell6-uk-1.4.0-0.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/uk/aspell6-uk-1.4.0-0.tar.bz2"
    sha256 "35f9a7e840c1272706bc6dd172bc9625cbd843d021094da8598a6abba525f18c"
  end

  resource "uz" do
    url "https://ftp.gnu.org/gnu/aspell/dict/uz/aspell6-uz-0.6-0.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/uz/aspell6-uz-0.6-0.tar.bz2"
    sha256 "2281c1fc7fe2411f02d25887c8a68eaa2965df3cd25f5ff06d31787a3de5e369"
  end

  resource "vi" do
    url "https://ftp.gnu.org/gnu/aspell/dict/vi/aspell6-vi-0.01.1-1.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/vi/aspell6-vi-0.01.1-1.tar.bz2"
    sha256 "3cd85d53bb62b0d104cb5c03e142c3bbe1ad64329d7beae057854816dc7e7c17"
  end

  resource "wa" do
    url "https://ftp.gnu.org/gnu/aspell/dict/wa/aspell-wa-0.50-0.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/wa/aspell-wa-0.50-0.tar.bz2"
    sha256 "5a17aa8aa37afbcc8f52336476670b93cba16462bcb89dd46b80f4d9cfe73fe4"
  end

  resource "yi" do
    url "https://ftp.gnu.org/gnu/aspell/dict/yi/aspell6-yi-0.01.1-1.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/yi/aspell6-yi-0.01.1-1.tar.bz2"
    sha256 "9879d35a5b0b86f8e217601568480f2f634bc8b7a97341e9e80b0d40a8202856"
  end

  resource "zu" do
    url "https://ftp.gnu.org/gnu/aspell/dict/zu/aspell-zu-0.50-0.tar.bz2"
    mirror "https://ftpmirror.gnu.org/aspell/dict/zu/aspell-zu-0.50-0.tar.bz2"
    sha256 "3fa255cd0b20e6229a53df972fd3c5ed8481db11cfd0347dd3da629bbb7a6796"
  end

  # const problems with llvm: https://www.freebsd.org/cgi/query-pr.cgi?pr=180565&cat=
  patch :DATA

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"

    ENV.prepend_path "PATH", bin

    resources.each do |r|
      r.stage do
        system "./configure", "--vars", "ASPELL=#{bin}/aspell", "PREZIP=#{bin}/prezip"
        system "make", "install"
      end
    end
  end

  test do
    assert_equal "worrd", pipe_output("#{bin}/aspell list -d en_US", "misspell worrd").strip
  end
end

__END__
diff --git a/interfaces/cc/aspell.h b/interfaces/cc/aspell.h
index 9c8e81b..2cd00d4 100644
--- a/interfaces/cc/aspell.h
+++ b/interfaces/cc/aspell.h
@@ -237,6 +237,7 @@ void delete_aspell_can_have_error(struct AspellCanHaveError * ths);
 /******************************** errors ********************************/


+#ifndef __cplusplus
 extern const struct AspellErrorInfo * const aerror_other;
 extern const struct AspellErrorInfo * const aerror_operation_not_supported;
 extern const struct AspellErrorInfo * const   aerror_cant_copy;
@@ -322,6 +323,7 @@ extern const struct AspellErrorInfo * const   aerror_missing_magic;
 extern const struct AspellErrorInfo * const   aerror_bad_magic;
 extern const struct AspellErrorInfo * const aerror_expression;
 extern const struct AspellErrorInfo * const   aerror_invalid_expression;
+#endif


 /******************************* speller *******************************/
